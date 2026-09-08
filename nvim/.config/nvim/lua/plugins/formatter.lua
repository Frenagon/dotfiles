return {
	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				timeout_ms = 1000,
			},
			formatters = {
				biome = {
					require_cwd = true,
				},
				prettier = {
					require_cwd = true,
				},
			},
		},
	},
}
