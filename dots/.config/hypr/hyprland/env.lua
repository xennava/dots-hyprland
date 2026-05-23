local home_dir = os.getenv("HOME")

-- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

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
		-- 1. Cari posisi titik dua (:) berikutnya
		local next_colon = string.find(str, ":", i, true) -- true = pencarian teks biasa, sangat cepat
		local e = next_colon and (next_colon - 1) or len

		-- 2. Validasi: pastikan segmen tidak kosong
		if e >= i then
			-- 3. Cek karakter pertama tanpa memotong string (menghindari alokasi memori)
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

-- Themes
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

-- Virtual environment
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", home_dir .. "/.local/state/quickshell/.venv")
