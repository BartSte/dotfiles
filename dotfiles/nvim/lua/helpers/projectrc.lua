local path = require("helpers.path")

local M = {}

--- Get the name of the current project. This name can be retrieved from the
--- environment variable PROJECTRC. If the environment variable is not set,
--return an empty string.
M.name = function()
    local name = vim.fn.getenv("PROJECTRC")
    if name == vim.NIL then
        return ""
    else
        return name
    end
end

-- Require the lua file in the same directory as the script that calls this
-- function. The name of the file is determined by the value of the PROJECTRC
-- environment variable. If the file is not found, the default file name is used
-- that can be set by the `default` argument (default is "default").
--
-- For example:
-- - the script that calls this function is located at `/xyz/init.lua`
-- - the PROJECTRC environment variable is set to "foo"
-- Now, the file `/xyz/foo.lua` will be loaded. If the file is not found, the
-- file `/xyz/default.lua` will be loaded. If this one is not found, an empty
-- table is returned.
--
-- The level argument is optional and is used as the level of the debug.getinfo
-- function. The default value is 3, and should be increades when you want to
-- load the module from one level higher in the call stack.
---@param default string default module to load if the project module is not
--found.
---@param level number optional level to use for the debug.getinfo function. To
--return the path to the caller of the function, use 3 which is the default.
---@return any any whatever the required module returns
M.load = function(default, level)
    default = default or "default"
    level = level or 3

    local parent_module = path.module(3)
    local options = { M.name(), default }
    for _, file in ipairs(options) do
        local module = path.module_join(parent_module, file)
        local ok, result = pcall(require, module)
        if ok then
            return result
        end
    end
    return {}
end


return M
