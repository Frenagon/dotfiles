return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				biome = {},
				vtsls = {
					settings = {
						typescript = {
							preferences = {
								-- Use the shorter key for vtsls
								importModuleSpecifier = "non-relative",
							},
						},
						javascript = {
							preferences = {
								importModuleSpecifier = "non-relative",
							},
						},
					},
				},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				["javascript.jsx"] = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },
				["typescript.jsx"] = { "biome", "prettier", stop_after_first = true },
			},
		},
	},
}
