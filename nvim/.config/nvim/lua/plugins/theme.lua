-- Follow the Omarchy (Quattro / v4.0.0+) system theme.
--
-- `omarchy-theme-set` writes a lazy.nvim spec to the state file below on every
-- theme change. Omarchy assumes a LazyVim base and names the colorscheme via a
-- `LazyVim/LazyVim` opts entry:
--
--     return {
--       { "folke/tokyonight.nvim", priority = 1000 },
--       { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
--     }
--
-- This config is not LazyVim, so returning that verbatim would install and
-- bootstrap LazyVim for nothing. Instead:
--
--   * discover every theme plugin Omarchy could name -- one per `neovim.lua`
--     under its bundled themes and the user's own themes, plus aether.nvim
--     (what every colours-only or git-installed theme renders to) -- and return
--     them all as `lazy = true` specs, so they are cloned but cost nothing at
--     startup;
--   * read the current colorscheme out of the state file's LazyVim entry, load
--     just that theme's plugin, and apply it;
--   * poll the state file (same 2s cadence as lazy.nvim's own change_detection,
--     which can't see this path -- it lives outside the config dir) and
--     re-apply on later `omarchy-theme-set` runs, without restarting Neovim.
--
-- When the state file is absent (no Omarchy, or no theme picked yet) this
-- returns nothing and plugins/colorscheme.lua applies catppuccin instead.

local omarchy = vim.env.OMARCHY_PATH or "/usr/share/omarchy"
local user_themes = vim.fn.expand("~/.config/omarchy/themes")
local state_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

--- lazy.nvim short name + setup() module for a spec (mirrors lazy's own guess).
local function names(spec)
	local name = spec.name or spec[1]:match("([^/]+)$")
	return name, (name:gsub("%.nvim$", ""))
end

--- dofile a theme's neovim.lua, tolerating anything missing or malformed.
local function load_spec(path)
	if not vim.uv.fs_stat(path) then
		return nil
	end
	local ok, list = pcall(dofile, path)
	return (ok and type(list) == "table") and list or nil
end

--- The theme plugin spec out of an Omarchy `neovim.lua` return value.
local function theme_plugin(list)
	for _, p in ipairs(list) do
		if type(p) == "table" and type(p[1]) == "string" and p[1] ~= "LazyVim/LazyVim" then
			return {
				p[1],
				name = p.name,
				branch = p.branch,
				build = p.build,
				dependencies = p.dependencies,
				opts = p.opts,
			}
		end
	end
end

--- colorscheme + background out of the `LazyVim/LazyVim` entry.
local function theme_opts(list)
	for _, p in ipairs(list) do
		if type(p) == "table" and p[1] == "LazyVim/LazyVim" and type(p.opts) == "table" then
			return p.opts.colorscheme, p.opts.background
		end
	end
end

--- Every theme plugin Omarchy could ask for, deduped, as `lazy = true` specs.
local function discover()
	local specs, seen = {}, {}
	local function scan(root)
		if not vim.uv.fs_stat(root) then
			return
		end
		for entry, ty in vim.fs.dir(root) do
			if ty == "directory" then
				local list = load_spec(root .. "/" .. entry .. "/neovim.lua")
				local p = list and theme_plugin(list)
				if p and not seen[p[1]] then
					seen[p[1]] = true
					p.opts = nil
					p.lazy = true
					specs[#specs + 1] = p
				end
			end
		end
	end
	scan(omarchy .. "/themes")
	scan(user_themes)
	if not seen["bjarneo/aether.nvim"] then
		specs[#specs + 1] = { "bjarneo/aether.nvim", name = "aether", branch = "v3", lazy = true }
	end
	return specs
end

--- Set background + colorscheme now, and re-assert transparency.
local function paint(colorscheme, background)
	-- Omarchy sometimes puts a theme-plugin-specific value here (everforest's
	-- "soft"); only "light"/"dark" mean anything to 'background'.
	if background == "light" or background == "dark" then
		vim.o.background = background
	end
	if colorscheme then
		pcall(vim.cmd.colorscheme, colorscheme)
	end
	-- plugin/transparency.lua re-runs on ColorScheme, but source it directly too:
	-- switching between two colours-only themes keeps colorscheme == "aether", so
	-- the call above is a no-op and fires no event.
	local transparency = vim.fn.stdpath("config") .. "/plugin/transparency.lua"
	if vim.uv.fs_stat(transparency) then
		pcall(vim.cmd.source, transparency)
	end
end

--- Poll the state file; re-apply on change. fs_poll re-stats by path, so it
--- survives Omarchy replacing the whole current/theme/ directory (rm -rf + mv).
local function watch()
	local poll = vim.uv.new_fs_poll()
	if not poll then
		return
	end
	poll:start(state_file, 2000, function()
		vim.schedule(function()
			local list = load_spec(state_file)
			if not list then
				return
			end
			local colorscheme, background = theme_opts(list)
			local plugin = theme_plugin(list)
			if plugin then
				local name, mod = names(plugin)
				if not require("lazy.core.config").plugins[name] then
					vim.notify(
						("omarchy-theme: %s needs %s -- restart Neovim to install it"):format(
							colorscheme or "?",
							plugin[1]
						),
						vim.log.levels.WARN
					)
					return
				end
				require("lazy").load({ plugins = { name } })
				if type(plugin.opts) == "table" and next(plugin.opts) then
					pcall(function()
						require(mod).setup(plugin.opts)
					end)
				end
			end
			paint(colorscheme, background)
		end)
	end)
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			pcall(function()
				poll:stop()
			end)
		end,
	})
end

local state = load_spec(state_file)
if not state then
	return {}
end

local colorscheme, background = theme_opts(state)
if not colorscheme then
	return {}
end
local current = theme_plugin(state)
local current_name = current and names(current)

local specs = discover()

-- Promote the current theme's spec: load it non-lazily at startup, with the
-- state file's opts so lazy runs its setup() (aether carries per-theme colours).
local promoted = false
for _, p in ipairs(specs) do
	if current_name and names(p) == current_name then
		p.lazy = false
		p.priority = 1000
		p.opts = current.opts
		promoted = true
	end
end

-- Current theme plugin isn't one Omarchy ships or the user staged (a
-- hand-written theme dir): add it straight from the state file spec.
if current and not promoted then
	current.lazy = false
	current.priority = 1000
	specs[#specs + 1] = current
end

-- Virtual plugin (same trick as omarchy-nvim's theme-hotreload): once the theme
-- plugin above has loaded, apply the colorscheme and arm the poller.
specs[#specs + 1] = {
	name = "omarchy-theme-watch",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 900,
	config = function()
		paint(colorscheme, background)
		watch()
	end,
}

return specs
