-- Omarchy (Quattro / v4.0.0+) writes a lazy.nvim plugin spec to
-- ~/.local/state/omarchy/current/theme/neovim.lua whenever the system theme
-- changes, so Neovim's colorscheme follows the OS theme. Loading it here is
-- the community-standard integration point (see e.g. nedpranson/
-- omarchy-themer, EskelinenAntti/omarchy-theme-loader.nvim, and the
-- neovim.lua files shipped by individual omarchy-*-theme repos) — the state
-- directory itself is Quattro-specific (pre-Quattro used
-- ~/.config/omarchy/current/theme/ instead).
--
-- If it's absent (no Omarchy on this machine, or no theme set yet), fall back to
-- catppuccin — see plugins/colorscheme.lua.
local omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.uv.fs_stat(omarchy_theme) then
	return dofile(omarchy_theme)
end

return {}
