local vars = require("hypr.variables")
local obsidian = require("hypr.programs.obsidian")

hl.on("hyprland.start", function()
	-- Guard against a browser instance surviving from a previous Hyprland
	-- session (uwsm launches it as an independent systemd scope, so it
	-- outlives a compositor restart): without this check, every restart
	-- launches a second instance on top of the one still running.
	hl.exec_cmd(
		vars.run_if_closed .. " --class '" .. vars.browserClass .. "' -- uwsm app -- " .. vars.browser,
		{ workspace = "1 silent" }
	)
	hl.exec_cmd("omarchy-launch-terminal-tmux", { workspace = "2 silent" })
	hl.exec_cmd(
		"uwsm app -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultVault
			.. "' & uwsm app -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultGameVault
			.. "'"
	)
	hl.exec_cmd("uwsm app -- " .. vars.music, { workspace = "5 silent" })
end)
