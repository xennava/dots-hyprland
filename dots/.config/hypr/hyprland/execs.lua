-- put former exec-once commands inside the func and former exec commands outside
hl.on("hyprland.start", function()
	local startup_commands = {
		-- Bar, wallpaper
		"$HOME/.config/hypr/hyprland/scripts/start_geoclue_agent.sh",
		"qs -c $qsConfig",
		"$HOME/.config/hypr/custom/scripts/__restore_video_wallpaper.sh",

		-- Core components
		"gnome-keyring-daemon --start --components=secrets",
		"hypridle",
		"dbus-update-activation-environment --all",
		-- Delay to ensure the user systemd session is fully initialized.
		"sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

		-- Audio
		"easyeffects --hide-window --service-mode",

		-- Cursor
		"hyprctl setcursor Bibata-Modern-Classic 24",
	}

	for _, cmd in ipairs(startup_commands) do
		hl.exec_cmd(cmd)
	end

	local cliphist_update = "bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	for _, t in ipairs({ "text", "image" }) do
		hl.exec_cmd(("wl-paste --type %s --watch %s"):format(t, cliphist_update))
	end
end)
