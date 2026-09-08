return {
	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			local map = require("utils").map
			map("n", "<leader>;", dropbar_api.pick, "Pick symbols in winbar")
			map("n", "[;", dropbar_api.goto_context_start, "Go to start of current context")
			map("n", "];", dropbar_api.select_next_context, "Select next context")
		end,
	},
}
