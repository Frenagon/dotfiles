return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				markdown = { "prettier" },
				["markdown.mdx"] = { "prettier" },
			},
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
