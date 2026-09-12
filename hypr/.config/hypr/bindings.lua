local vars = require("hypr.variables")
local obsidian = require("hypr.programs.obsidian")

local mainMod = vars.mainMod
local terminalClass = vars.terminalClass
local browser = vars.browser
local browserClass = vars.browserClass
local music = vars.music
local musicTitle = vars.musicTitle

local run_if_closed = vars.run_if_closed

-- Open the app on this workspace only if it isn't already running. Omarchy's
-- own defaults already bind SUPER+<number> to switch workspaces; these add
-- to that (not replace it) so the first press also launches the app.
hl.bind(mainMod .. " + 1", hl.dsp.exec_cmd(run_if_closed .. " --class '" .. browserClass .. "' --workspace 1 -- " .. browser))
hl.bind(mainMod .. " + 2", hl.dsp.exec_cmd(run_if_closed .. " --class '" .. terminalClass .. "' --workspace 2 -- omarchy-launch-terminal-tmux"))
hl.bind(
	mainMod .. " + 3",
	hl.dsp.exec_cmd(
		run_if_closed
			.. " --title '"
			.. obsidian.title
			.. "' --regex --workspace 3 -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultVault
			.. "'"
	)
)
hl.bind(
	mainMod .. " + 4",
	hl.dsp.exec_cmd(
		run_if_closed
			.. " --title '"
			.. obsidian.title
			.. "' --regex --workspace 4 -- xdg-open 'obsidian://open?vault="
			.. obsidian.defaultGameVault
			.. "'"
	)
)
hl.bind(mainMod .. " + 5", hl.dsp.exec_cmd(run_if_closed .. " --title '" .. musicTitle .. "' --regex --workspace 5 -- " .. music))
hl.bind(mainMod .. " + 6", hl.dsp.exec_cmd(run_if_closed .. " --class 'Godot' --workspace 6 -- godot"))

-- The silvaio.gamemode bar plugin (~/.config/omarchy/plugins/silvaio.gamemode)
-- doesn't wire up a keybind itself; its README says to add this.
o.bind(mainMod .. " + CTRL + G", "Game Mode", "omarchy-shell silvaio.gamemode toggleMode")
