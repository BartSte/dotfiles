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
local function append(module, default)
    local name = M.name()
    if name == "" then
        return module .. "." .. default
    else
        return module .. "." .. name
    end
end

M.require = function(module)
    local name = append(module, "default")
    return require(name)
end

return M
