local M = {}

M.print_table = function(t)
    for key, value in pairs(t) do
        if type(value) == "table" then
            print(key .. ":")
            M.print_table(value) -- Recursive call to print nested tables
        else
            print(key .. ": " .. tostring(value))
        end
    end
end

M.file = function(level)
    level = level or 2
    return debug.getinfo(level, "S").source:sub(2)
end

--- Return the directory of the script that calls this function. The level
--- argument is optional and is set to 2 by default, i.e., the path of the script
--- that calls this function. If you use this function in another function, you
--- need to increase the level by 1.
---@param level integer optional level to use for the debug.getinfo function.
---@return string dir The directory of the script.
M.dir = function(level)
    level = level or 2
    -- debug needs to be called here explicitly in order to keep the same
    -- default call stack level as the other functions of 1.
    local file = debug.getinfo(level, "S").source:sub(2)
    return file:match("(.*/)") or file:match("(.*/)")
end

--- Return the module name of the script that calls this function. The level
--- argument is optional and is set to 2 by default, i.e., the path of the script
--- that calls this function. If you use this function in another function, you
--- need to increase the level by 1.
---@param level integer optional level to use for the debug.getinfo function. To
--return the path of the caller of this function, use 2.
---@return
M.module = function(level)
    level = level or 2
    -- debug needs to be called here explicitly in order to keep the same
    -- default call stack level as the other functions of 2.
    local file = debug.getinfo(level, "S").source:sub(2)
    local dir = file:match("(.*/)") or file:match("(.*/)")
    return M.dir_to_module(dir)
end

return M
