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

--- Append the name of the current project to a module name. If the name of the
--- current project is an empty string, append the default name to the module
--- name.
---@param module string name of the module
---@vararg string default name of the module
local function append_name(module, default)
    default = default or "default"
    local name = M.name()
    if name == "" then
        return module .. "." .. default
    else
        return module .. "." .. name
    end
end

--- Load the module holding project specific configuration. Note that the
--path.module function is called with level 3, meaning that the module of the
--caller of this function is used, not the module of this function.
---@return any any whatever the required module returns
M.load = function()
    local caller_module = path.module(3)
    local required_module = append_name(caller_module)
    return require(required_module)
end


return M
