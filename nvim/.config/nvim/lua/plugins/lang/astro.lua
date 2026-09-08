return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				astro = {},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				astro = { "biome", "prettier", stop_after_first = true },
			},
		},
	},
}
