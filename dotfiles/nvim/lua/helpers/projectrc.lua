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
        name = default
    end
    return module .. "." .. name
end

--- Try to require the module. If the module is not found, return the `default`
--parameter. If the default parameter is not set, return an empty table.
---@param module string name of the module
---@param default any default value to return if the module is not found.
---@return any any whatever the required module returns
local function save_require(module, default)
    default = default or {}
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        return default
    end
end

--- Load the module holding project specific configuration. Note that the
--path.module function is called with level 3, meaning that the module of the
--caller of this function is used, not the module of this function.
---@return any any whatever the required module returns
M.load = function()
    -- TODO: when the PROJECTRC does not extst, the default should be loaded.
    -- Currently, the default is only loaded when the PROJECTRC is an empty
    -- string.
    local caller_module = path.module(3)
    local required_module = append_name(caller_module)
    return save_require(required_module)
end


return M
