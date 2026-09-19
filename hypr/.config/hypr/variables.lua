return {
	-- Apps
	-- Window class of whatever terminal xdg-terminal-exec resolves to
	-- (ghostty's GTK app-id is "com.mitchellh.ghostty", not the binary name).
	terminalClass = "com.mitchellh.ghostty",
	browser       = "zen-browser",
	-- Window class for `run_if_closed --class`. zen-browser-bin ships
	-- StartupWMClass=zen; confirm against `hyprctl clients` if SUPER+1 keeps
	-- spawning new windows instead of focusing the existing one.
	browserClass  = "zen",
	-- ytmdesktop's AUR package installs its binary as youtube-music-desktop-app.
	music         = "youtube-music-desktop-app",
	musicTitle    = ".*YouTube Music.*",

	-- Full paths: Hyprland's compositor environment doesn't have
	-- ~/.local/scripts on PATH (only .bashrc adds it), so a bare name here
	-- would resolve to the wrong binary.
	run_if_closed = os.getenv("HOME") .. "/.local/scripts/run_if_closed",
	terminalTmux = os.getenv("HOME") .. "/.local/scripts/omarchy-launch-terminal-tmux",

	-- Modifier
	mainMod       = "SUPER",
}
