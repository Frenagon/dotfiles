local vars = require("hypr.variables")
local obsidian = require("hypr.programs.obsidian")

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- " .. vars.browser, { workspace = "1 silent" })
	hl.exec_cmd("uwsm app -- " .. vars.terminal, { workspace = "2 silent" })
	hl.exec_cmd(
		"uwsm app -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultVault
			.. "' & uwsm app -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultGameVault
			.. "'"
	)
	hl.exec_cmd("uwsm app -- " .. vars.music, { workspace = "5 silent" })
end)
