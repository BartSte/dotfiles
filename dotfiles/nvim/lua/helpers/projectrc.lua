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

--- Require the lua a lua file from the `parent` directory. The name of the file
--- is determined by the value of the PROJECTRC environment variable. If the
--- file is not found, the default file name is used that can be set by the
--- `default` argument (default is "default").
---
--- For example:
--- - the parent directory is `/xyz/`
--- - the PROJECTRC environment variable is set to "foo"
--- Now, the file `/xyz/foo.lua` will be loaded. If the file is not found, the
--- file `/xyz/default.lua` will be loaded. If this one is not found, an empty
--- table is returned.
---
--- If the `parent` argument is not set (or nil), the parent directory is
--- determined using `path.module` function. The `level` argument is passed to
--- the `path.module` function and is set to 3 by default, i.e., the path of the
--- script that calls this function.
---
--- For example:
--- - The function is called with no arguments.
--- - The script is located at `/xyz/init.lua`
--- - The PROJECTRC environment variable is set to "foo"
--- Now, the file `/xyz/foo.lua` will be loaded. If the file is not found, the
--- file `/xyz/default.lua` will be loaded. If this one is not found, an empty
--- table is returned.
---
---@param parent string optional parent directory of the module to require. If
--- not set, the parent directory is determined using the `path.module`
--- function.
---@param default string optional default file name to require. If not set,
--- the default file name is "default".
---@param level integer optional level to use for the `path.module` function. If
--- not set, the level is 3, i.e., the path of the script that calls this
--- function.
---@return any any The required module or an empty table.
M.require = function(parent, default, level)
    level = level or 3
    parent = parent or path.module(level)
    default = default or "default"

    local options = { M.name(), default }
    for _, file in ipairs(options) do
        local module = path.module_join(parent, file)
        local ok, result = pcall(require, module)
        if ok then
            return result
        end
    end
    return {}
end

return M
