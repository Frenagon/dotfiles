local terminal = "foot"

return {
	-- Apps
	terminal      = terminal,
	terminalClass = terminal,
	browser       = "zen-browser",
	-- Window class for `run_if_closed --class`. zen-browser-bin ships
	-- StartupWMClass=zen; confirm against `hyprctl clients` if SUPER+1 keeps
	-- spawning new windows instead of focusing the existing one.
	browserClass  = "zen",
	-- ytmdesktop's AUR package installs its binary as youtube-music-desktop-app.
	music         = "youtube-music-desktop-app",
	musicTitle    = ".*YouTube Music.*",

	-- Modifier
	mainMod       = "SUPER",
}
