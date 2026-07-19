VERSION = "1.0.0-G3Dev"

local micro = import("micro")
local shell = import("micro/shell")

-- separate functions for running fuzzy search in word or regex mode
function wordfzf(bp)
	contentfzf(bp, "w")
end

function regexfzf(bp)
	contentfzf(bp, "r")
end

function contentfzf(bp, mode)
    -- suspend micro and leave terminal control to fzf
    shell.RunInteractiveShell("bash /home/gabry/.config/micro/plug/altfzf/content_fuzzy_search.sh " .. mode, false, true)

    -- read the temporary file with fuzzy search result
    local f = io.open("/tmp/micro_fzf_result", "r")
    if f then
        local result = f:read("*all")
        f:close()
        os.remove("/tmp/micro_fzf_result")

        -- decompose the result (format file:line:column:text)
        if result and result ~= "" then
            -- use regex to extract filepath and line number
            local filepath, line, column = string.match(result, "([^:]+):(%d+):(%d+):")

            if filepath then
                -- open the file in a new tab using the native micro command
                bp:HandleCommand("tab " .. filepath)

                if line then
					-- move the cursor on the CurPane (the currently focues pane)
					micro.CurPane():HandleCommand("goto " .. line .. ":" .. column)
                end
            end
        end
    end
end
