local home_dir = os.getenv("HOME")

local env_vars = {
	-- Themes
	QT_QPA_PLATFORM = "wayland;xcb",
	QT_QPA_PLATFORMTHEME = "kde",
	XDG_MENU_PREFIX = "plasma-",
	-- Virtual environment
	ILLOGICAL_IMPULSE_VIRTUAL_ENV = home_dir .. "/.local/state/quickshell/.venv",
	-- Wayland
	ELECTRON_OZONE_PLATFORM_HINT = "auto",
}

for k, v in pairs(env_vars) do
	hl.env(k, v)
end

-- Applications
local function unique_paths_extreme(str)
	if not str or str == "" then
		return ""
	end

	local seen = {}
	local result = {}
	local count = 0
	local i = 1
	local len = #str

	while i <= len do
		local next_colon = string.find(str, ":", i, true) -- true = pencarian teks biasa, sangat cepat
		local e = next_colon and (next_colon - 1) or len

		if e >= i then
			if string.byte(str, i) ~= 36 then -- 36 adalah kode ASCII untuk karakter '$'
				local path = string.sub(str, i, e)
				if not seen[path] then
					seen[path] = true
					count = count + 1
					result[count] = path
				end
			end
		end

		i = e + 2
	end

	return table.concat(result, ":")
end

local base_xdg = home_dir
	.. "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"

local current_xdg = os.getenv("XDG_DATA_DIRS") or ""

local combined_xdg = (current_xdg ~= "") and (base_xdg .. ":" .. current_xdg) or base_xdg

hl.env("XDG_DATA_DIRS", unique_paths_extreme(combined_xdg))
