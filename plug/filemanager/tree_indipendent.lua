local micro = import("micro")
local config = import("micro/config")

SCRIPT_NAME="file_utils.sh"

-- Triggered with "file filename"
function create_file(bp, args)

	-- Safety check they actually passed a name
	if #args < 1 then
		micro.InfoBar():Error('When using "touch" you need to input a file name')
		return
	end

	local file_name = args[1]

	-- Run the proper script
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/filemanager/" .. SCRIPT_NAME
	micro.CurPane():HandleCommand("run bash " .. script_path .. " -f " .. file_name)
end

-- Triggered with "dir dirname"
function create_dir(bp, args)

	-- Safety check they actually passed a name
	if #args < 1 then
		micro.InfoBar():Error('When using "mkdir" you need to input a dir name')
		return
	end

	local dir_name = args[1]

	-- Run the proper script
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/filemanager" .. SCRIPT_NAME
	micro.CurPane():HandleCommand("run bash " .. script_path .. " -c " .. dir_name)
end

-- Triggered with "duplicate source_filename dest_filename"
function duplicate_file(bp, args)

	-- Safety check they actually passed a name
	if #args < 2 then
		micro.InfoBar():Error('When using "duplicate" you need to input a source file name and a destination file name: duplicate <source_filename> <dest_filename>')
		return
	end

	local source_file_name = args[1]
	local dest_file_name = args[2]

	-- Run the proper script
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/filemanager/".. SCRIPT_NAME
	micro.CurPane():HandleCommand("run bash " .. script_path .. " -d " .. source_file_name .. " " .. dest_file_name)
end

function init()
    config.MakeCommand("file", create_file, config.NoComplete)
    config.MakeCommand("dir", create_dir, config.NoComplete)
    config.MakeCommand("duplicate", duplicate_file, config.NoComplete)
end
