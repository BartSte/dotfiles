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

--- Try to require a module from the `parent` directory. The `files` argument is
--- a list of file names. The function tries to require each file in the list
--- and returns the first module that can be required. If no module can be
--- required, an empty table is returned.
---@param parent string The parent directory of the module to require.
---@param files table The list of file names to require.
---@param return_value any optional The value to return if no module can be
--- required.
---@return any result The required module or the value of `return_value`.
local function try_require(parent, files, return_value)
    return_value = return_value or {}
    for _, file in ipairs(files) do
        local module = path.module_join(parent, file)
        local ok, result = pcall(require, module)
        if ok then
            return result
        end
    end
    return return_value
end

--- Helper function to filter out nil values from a table
---@param v any A value to that can be nil.
---@return boolean result True if the value is not nil, false otherwise.
local function filter_nill(v)
    return v ~= nil
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
---@param parent string optional parent directory of the module to require.
---@param default Optional | string | nil default file name to require. If not set,
--- the default file name is "default". If the default file name is set to `nil`,
--- the default file is not loaded.
---@return any any The required module or an empty table.
M.require = function(parent, default)
    default = default or "default"
    local files = vim.tbl_filter(filter_nill, { M.name(), default })
    return try_require(parent, files)
end


--- Run the `require` function but do not load the default file if the file is
--- listed in the `no_default` table. The `no_default` table is a list of file
--- names.
---
--- For example:
--- - the parent directory is `/xyz/`
--- - the PROJECTRC environment variable is set to "foo"
--- - the no_default table is `{"foo", "bar"}`
--- Now, when the file `/xyz/foo.lua` does not exist, the file `/xyz/default.lua`
--- will not be loaded. Instead, an empty table is returned.
---@param no_default table list of file names to no_default.
---@param parent string see `require` function
---@param default Optional | string | nil see `require` function
---@return any module The required module or an empty table.
M.require_no_default = function(no_default, parent, default)
    if vim.tbl_contains(no_default, M.name()) then
        default = nil
    else
        default = default or "default"
    end
    return M.require(parent, default)
end

return M
