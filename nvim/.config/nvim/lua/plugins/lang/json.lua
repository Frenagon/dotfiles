return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				jsonls = {
					cmd = { "vscode-json-language-server", "--stdio" },
				},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				json = { "biome", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettier", stop_after_first = true },
			},
		},
	},
}
