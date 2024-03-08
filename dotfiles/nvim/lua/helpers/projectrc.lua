local path = require("helpers.path")
local merge_opts = require("helpers.opts").merge_opts

local M = {}

--- If the `obj` is a function, call it and return the result. If it is not a
--- function, return the `obj`.
---@param obj
local function call_or_return(obj)
    if type(obj) == "function" then
        return obj()
    else
        return obj
    end
end

--- Try to require the module: "{parent}.{file}". If it fails, return the
--- `return_value`.
---@param parent string The parent directory of the module to require.
---@param file string | nil The file in the parent directory to require.
---@param default any | nil The value to return if no module can be required. If it
--- is a function, call it and return the result. If it is not a function, return
--- the value.
---@return any result The required module or the value of `return_value`.
M.try_require = function(parent, file, default)
    local module = path.module_join(parent, file)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        return call_or_return(default)
    end
end

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

---@param parent string The require path of the parent module.
---@param opts table | nil The options to use when requiring the module. These
--- are the same options as the global `opts` table, but now they are only
--- applied in this function.
---@return any result The required module or the value that is returned by the
--- `opts.callback` function.
M.require = function(parent, opts)
    opts = merge_opts(opts, M.defaults)

    local default = function()
        return opts.callback(parent, opts.fallback_file, opts.fallback_value)
    end

    return M.try_require(parent, M.name(), default)
end

M.defaults = {
    fallback_file = "default",
    fallback_value = {},
    callback = M.try_require,
}

--- Change the default options for the whole module.
---@param opts table | nil The options to change the default options to.
M.setup = function(opts)
    M.defaults = merge_opts(opts, M.defaults)
end


return M
