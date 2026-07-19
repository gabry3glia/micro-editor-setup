VERSION = "1.0.0-G3Dev"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")

local BUILD_FILE = "build.jp"

-- BUILD RELATED FUNCTIONS
function projectBuild(bp)
    micro.InfoBar():Message("Building project...")
    
    local home = os.getenv("HOME")
    local build_script = home .. "/.config/micro/plug/javautils/build.sh"
    
    -- Utilizziamo shell.JobSpawn dopo aver verificato l'import corretto
    shell.JobSpawn("bash", {build_script}, 
        nil, nil, 
        function(output)
            output = string.gsub(output, "%s+$", "") -- Pulisce i ritorni a capo
            
            if string.find(output, "BUILD_STATUS:SUCCESS") then
                -- Estrae il messaggio pulito togliendo il prefisso di controllo
                local msg = string.gsub(output, "BUILD_STATUS:SUCCESS %- ", "")
                micro.InfoBar():Message(msg)
            else
                local err_msg = string.gsub(output, "BUILD_STATUS:ERROR %- ", "")
                if err_msg == output then err_msg = "Build failed! Check " .. BUILD_FILE .. " configuration." end
                micro.InfoBar():Error(err_msg)
            end
        end
    )
end

-- RELEASE RUN RELATED FUNCTIONS
function releaseRun(bp, args)    
    local program = nil    
    local file = io.open(BUILD_FILE, "r")
    if file then
        for line in file:lines() do
            -- Get jar name
            local target = line:match("^TARGET:%s*(.-%.jar)")
            if target then
                program = target
                break
            end
        end
        file:close()
    end
    
    -- Fallback error handling if build.jp is missing or badly configured
    if program == nil or program == "" then
        micro.InfoBar():Error("Error: No target specified. Define TARGET: name.jar in " .. BUILD_FILE)
        return
    end
    
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/javautils/release_run.sh"
    
    micro.CurPane():HandleCommand("term bash " .. script_path .. " " .. program)
end

-- DEBUG RELATED FUNCTIONS (used for HOT SWAP)
function debugRun(bp, args)    
    local program = nil    
    local file = io.open(BUILD_FILE, "r")
    if file then
        for line in file:lines() do
            -- Get jar name
            local target = line:match("^TARGET:%s*(.-%.jar)")
            if target then
                program = target
                break
            end
        end
        file:close()
    end
    
    -- Fallback error handling if build.jp is missing or badly configured
    if program == nil or program == "" then
        micro.InfoBar():Error("Error: No target specified. Define TARGET: name.jar in " .. BUILD_FILE)
        return
    end
    
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/javautils/debug_run.sh"
    
    micro.CurPane():HandleCommand("term bash " .. script_path .. " " .. program)
end

-- HOT SWAP RELATED FUNCTIONS
function onSave(bp)
    -- Check if the current file is a Java file
    if bp.Buf.Settings["filetype"] == "java" then
        local filepath = bp.Buf.Path
        
        -- Extract the filename safely from the absolute path
        local filename = filepath:match("^.+/(.+)$") or filepath:match("^.+\\(.+)$") or filepath
        local classname = string.gsub(filename, ".java", "")
        
        local home = os.getenv("HOME")
        local hotswap_script = home .. "/.config/micro/plug/javautils/hotswap.sh"
        
        -- Run the command asynchronously
        shell.JobSpawn("bash", {hotswap_script, classname, filepath}, 
            nil, -- No real-time stdout chunks needed
            nil, -- No real-time stderr chunks needed
            
            -- FIX: Micro passes ONLY the final output string to this callback!
            function(output) 
                -- Purgiamo i ritorni a capo per evitare stringhe sporche
                output = string.gsub(output, "%s+$", "")

                -- We check if the script output contains our success keyword
                if string.find(output, "Successfully") then
                    micro.InfoBar():Message(output)
                elseif string.find(output, "NOT_RUNNING") then
                    -- The debug session wasn't active, so we cleaned up silently. 
                    -- Do not fill the InfoBar with errors.
                    return
                else
                    -- If the script printed a real execution error, show it in red
                    micro.InfoBar():Error("Hot Swap failed! Check if the debug session is running.")
                end
            end
        )
    end
end

-- PROJECT CLEAR FUNCTION
function clearProject(bp, args)    
	-- Run the proper script
    local home = os.getenv("HOME")
    local script_path = home .. "/.config/micro/plug/javautils/clear_project.sh"

   	-- THIS RUNS IT IN A NEW TERMINAL INSIDE MICRO
    --micro.CurPane():HandleCommand("term bash " .. script_path)
    -- THIS RUNS IT WHILE MICRO IS RUNNING WITHOUT OPENING A NEW TERMINAL MICRO TAB
    micro.CurPane():HandleCommand("run bash " .. script_path)
end

function init()
    config.MakeCommand("javaBuild", projectBuild, config.NoComplete)
    config.MakeCommand("javaRunRelease", releaseRun, config.NoComplete)
    config.MakeCommand("javaDebug", debugRun, config.NoComplete)
    config.MakeCommand("javaClearProject", clearProject, config.NoComplete)
end
