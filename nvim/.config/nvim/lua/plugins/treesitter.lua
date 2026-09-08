return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- main branch: the rewritten API. Highlighting and indentation are no
		-- longer enabled via opts — Neovim provides them and we start them
		-- per-buffer in a FileType autocmd below. Parsers are installed
		-- imperatively via require("nvim-treesitter").install().
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup()

			-- Parsers to keep installed (replaces the old `ensure_installed`).
			local ensure = {
				"astro",
				"bash",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"scss",
				"tsx",
				"typescript",
			}
			local have = {}
			for _, lang in ipairs(ts.get_installed()) do
				have[lang] = true
			end
			local missing = vim.tbl_filter(function(lang)
				return not have[lang]
			end, ensure)
			if #missing > 0 then
				ts.install(missing)
			end

			-- Filetypes we have parsers for. Start highlighting + treesitter
			-- indentation for each (replaces the old `highlight`/`indent` opts).
			local filetypes = {
				"astro",
				"bash",
				"css",
				"html",
				"javascript",
				"javascriptreact",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"nix",
				"scss",
				"sh",
				"typescript",
				"typescriptreact",
			}
			local function start(buf)
				if pcall(vim.treesitter.start, buf) then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nvim_treesitter_start", { clear = true }),
				pattern = filetypes,
				callback = function(args)
					start(args.buf)
				end,
			})
			-- Cover buffers already loaded before this config ran at startup.
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
					start(buf)
				end
			end
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocmd = false,
		},
	},

	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
}
