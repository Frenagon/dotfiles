local vars = require("hypr.variables")
local obsidian = require("hypr.programs.obsidian")

local musicTitle = vars.musicTitle

hl.window_rule({
	name = "obsidian-notes-workspace",
	match = {
		class = "obsidian|electron",
		title = "negative:.*(Campaign Notes|D&D 5E)" .. obsidian.title,
	},
	workspace = "3",
})

hl.window_rule({
	name = "obsidian-games-workspace",
	match = {
		class = "obsidian|electron",
		title = ".*(Campaign Notes|D&D 5E)" .. obsidian.title,
	},
	workspace = "4",
})

hl.window_rule({
	name = "music-workspace",
	match = {
		title = musicTitle,
	},
	workspace = "5",
})

hl.window_rule({
	name = "godot-workspace",
	match = {
		class = "Godot",
	},
	workspace = "6",
})

hl.window_rule({
	name = "gaming-workspace",
	match = {
		class = "net.lutris.Lutris|steam",
	},
	workspace = "10",
})
