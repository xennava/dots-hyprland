HOME = os.getenv("HOME")
local DEFAULT_CONTENT = [[
-- This file will not be overwritten across dots-hyprland updates.
-- The file name is for the sake of organization and does not matter
-- See the corresponding files in ~/.config/hypr/hyprland for examples
]]

function is_file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function create_if_not_exists(path)
	if is_file_exists(path) then
		return false
	end

	local dir = path:match("(.+)/[^/]+$")
	if dir then
		os.execute(('mkdir -p "%s"'):format(dir))
	end

	local file = assert(io.open(path, "w"))
	file:write(DEFAULT_CONTENT)
	file:close()

	return true
end

local GROUP_SIZE = workspaceGroupSize or 10

function workspace_in_group(i)
	local ws = hl.get_active_workspace()
	if not ws or not ws.id then
		return i
	end

	return (ws.id - 1) - ((ws.id - 1) % GROUP_SIZE) + i
end
