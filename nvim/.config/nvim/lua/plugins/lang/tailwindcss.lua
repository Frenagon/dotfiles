return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "twMerge\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								},
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
				html = { "biome", "prettier", stop_after_first = true },
				css = { "biome", "prettier", stop_after_first = true },
				less = { "prettier" },
				sass = { "prettier" },
				scss = { "prettier" },
			},
		},
	},

	{
		"eero-lehtinen/oklch-color-picker.nvim",
		event = "VeryLazy",
		version = "*",
		keys = {
			{
				"<leader>v",
				function()
					require("oklch-color-picker").pick_under_cursor()
				end,
				desc = "Color pick under cursor",
			},
		},
		opts = {
			auto_download = false,
		},
	},
}
