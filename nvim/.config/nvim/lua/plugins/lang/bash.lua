return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
		},
	},
}
