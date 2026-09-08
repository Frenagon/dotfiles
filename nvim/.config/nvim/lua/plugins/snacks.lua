---@module "snacks"

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = function()
			local snacks = require("snacks")
			local shell = os.getenv("SHELL") or vim.o.shell

			return {
				{ "<leader>E", snacks.picker.explorer, desc = "Snacks explorer" },
				{ "<leader>F", snacks.picker.files, desc = "Find files" },
				{ "<leader>n", snacks.scratch.open, desc = "Scratch pad" },
				{ "<leader>fn", snacks.scratch.select, desc = "Scratch pad" },
				{ "<leader>N", snacks.notifier.show_history, desc = "Show notifications" },
				{ "<leader>gb", snacks.git.blame_line, desc = "Show git blame" },
				{ "<leader>gr", snacks.gitbrowse.open, mode = { "n", "v" }, desc = "Open file in browser" },
				{ "<leader>gg", snacks.lazygit.open, desc = "Open lazygit" },
				{ "<leader>gL", snacks.lazygit.log, desc = "Show git logs" },
				{ "<leader>gl", snacks.lazygit.log_file, desc = "Show git file history" },
				{
					"<leader>.",
					function()
						snacks.terminal.toggle(shell)
					end,
					desc = "Open terminal",
				},
				{
					"<leader>,",
					function()
						local cwd = vim.fn.expand("%:p:h")
						if vim.fn.isdirectory(cwd) ~= 0 then
							snacks.terminal.toggle(shell, { cwd = cwd })
						end
					end,
					desc = "Open terminal",
				},
			}
		end,
		opts = {
			statuscolumn = {
				left = { "fold", "git" },
				right = { "mark", "sign" },
			},
			notifier = {},
			lazygit = {
				-- Remap lazygit's default theme colors via highlight groups:
				-- green->red, red->yellow, blue->green.
				theme = {
					activeBorderColor = { fg = "DiagnosticError", bold = true }, -- red
					optionsTextColor = { fg = "DiagnosticWarn" }, -- yellow
					selectedLineBgColor = { bg = "CursorLine" }, -- neutral line highlight
					cherryPickedCommitFgColor = { fg = "String" }, -- green
					unstagedChangesColor = { fg = "DiagnosticWarn" }, -- yellow
				},
			},
			indent = {
				scope = {
					treesitter = {
						enabled = false,
					},
				},
				animate = {
					enabled = false,
				},
			},
			styles = {
				terminal = {
					backdrop = 60,
					height = 0.9,
					width = 0.9,
					zindex = 50,
					border = "rounded",
				},
			},
		},
	},
}
