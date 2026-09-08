-- Installs the LSP servers/formatters that plugins/lsp.lua, plugins/lang/*.lua
-- and plugins/formatter.lua expect on $PATH. On the NixOS source machine these
-- come from home-manager (home/coding/default.nix); this is the portable
-- equivalent for machines without that provisioning.
return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"astro",
				"bashls",
				"biome",
				"emmet_ls",
				"eslint",
				"jsonls",
				"lua_ls",
				"marksman",
				"pyright",
				"tailwindcss",
				"vtsls",
			},
			-- plugins/lsp.lua already calls vim.lsp.config()/vim.lsp.enable()
			-- explicitly per server (opts.servers, merged in from plugins/lang/*.lua);
			-- mason-lspconfig should only ensure the binaries are installed, not
			-- also enable them itself. Verify this option name against whatever
			-- mason-lspconfig version lazy.nvim resolves — it has changed name
			-- across versions (e.g. automatic_enable / automatic_installation).
			automatic_enable = false,
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- Formatters not already covered as LSP servers above (biome is both).
			ensure_installed = {
				"black",
				"prettier",
				"shfmt",
				"stylua",
			},
		},
	},
}
