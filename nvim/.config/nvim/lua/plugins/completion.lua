return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"Kaiser-Yang/blink-cmp-avante",
		},
		version = "*",
		build = "cargo build --release",
		event = { "LspAttach" },
		opts = {
			keymap = {
				preset = "enter",
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			cmdline = {
				enabled = false,
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "markdown", "avante", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					markdown = {
						name = "RenderMarkdown",
						module = "render-markdown.integ.blink",
						fallbacks = { "lsp" },
					},
					avante = {
						name = "Avante",
						module = "blink-cmp-avante",
					},
				},
			},
			completion = {
				menu = {
					border = vim.g.border_style,
					scrolloff = 1,
					scrollbar = false,
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					window = {
						border = vim.g.border_style,
					},
				},
				trigger = {
					show_on_insert_on_trigger_character = false,
				},
			},
		},
		opts_extend = { "sources.default" },
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0,
			})
		end,
	},
}
