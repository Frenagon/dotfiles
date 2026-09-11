local vars = require("hypr.variables")
local obsidian = require("hypr.programs.obsidian")

local musicTitle = vars.musicTitle

-- Hyprland matches class/title with a full-string regex (RE2::FullMatch), so
-- patterns need their own leading/trailing ".*" to match a substring. Obsidian's
-- actual window class is "md.obsidian.Obsidian", which "obsidian|electron"
-- (unwrapped) never fully matches.
hl.window_rule({
	name = "obsidian-notes-workspace",
	match = {
		class = ".*(obsidian|electron).*",
		title = "negative:.*(Campaign Notes|D&D 5E)" .. obsidian.title,
	},
	workspace = "3 silent",
})

hl.window_rule({
	name = "obsidian-games-workspace",
	match = {
		class = ".*(obsidian|electron).*",
		title = ".*(Campaign Notes|D&D 5E)" .. obsidian.title,
	},
	workspace = "4 silent",
})

hl.window_rule({
	name = "music-workspace",
	match = {
		title = musicTitle,
	},
	workspace = "5 silent",
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
