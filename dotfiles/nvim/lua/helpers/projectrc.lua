local path = require("helpers.path")

local M = {}

M.opts = {
    default = "default",
    fallback = {}
}

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

--- Try to require the module: "{parent}.{file}". If it fails, return the
--- `return_value`.
---@param parent string The parent directory of the module to require.
---@param file string The file in the parent directory to require.
---@param return_value any The value to return if no module can be required.
---@return any result The required module or the value of `return_value`.
M.try_require = function(parent, file, return_value)
    local module = path.module_join(parent, file)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        return return_value
    end
end

--- TODO:
---@param parent
---@return
M.require_default = function(parent)
    return M.try_require(parent, M.opts.default, M.opts.fallback)
end

--- TODO: use a function as a default instead of a string
---@param parent string The require path of the parent module.
---@param default function | Optional The result of this function is returned if
--- the module cannot be required. If not set, the `require_default` function is
--- used.
M.require = function(parent, default)
    default = default or M.require_default
    local project_module = path.module_join(parent, M.name())
    local ok, result = pcall(require, project_module)
    if ok then
        return result
    else
        return default(parent)
    end
end

return M
