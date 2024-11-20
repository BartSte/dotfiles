local M = {}

---The file system path separator for the current platform.
M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
    M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
    local fields = {}

    local pattern = string.format("([^%s]+)", sep)

    local _ = string.gsub(inputString, pattern, function(c)
        fields[#fields + 1] = c
    end)

    return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.join = function(...)
    local args = { ... }
    if #args == 0 then
        return ""
    end

    local all_parts = {}
    if type(args[1]) == "string" and args[1]:sub(1, 1) == M.path_separator then
        all_parts[1] = ""
    end

    for _, arg in ipairs(args) do
        local arg_parts = M.split(arg, M.path_separator)

        vim.list_extend(all_parts, arg_parts)
    end
    return table.concat(all_parts, M.path_separator)
end

--- Return the home directory of the current user.
---@return string The home directory.
M.home = function()
    if vim.fn.has('win32') == 1 then
        return os.getenv('USERPROFILE')
    else
        return os.getenv('HOME')
    end
end

--- Return the require paths for all files in a directory. The second argument
--is optional.
---@param directory string directory to search for files.
---@param exclude string A pattern to exclude files.
---@return table string A table of the require paths.
M.glob_modules = function(directory, exclude)
    local default = M.path_separator .. "init$"
    exclude = exclude or default
    local path = require("helpers.path")
    local include = path.join(directory, "*.lua")

    local modules = {}
    local files = vim.fn.glob(include, false, true)
    for _, file in ipairs(files) do
        local lua_file = file:match('lua' .. M.path_separator .. '(.*)%.lua')
        if not lua_file:match(exclude) then
            local module = lua_file:gsub(path.path_separator, ".")
            modules[#modules + 1] = module
        end
    end

    return modules
end

--- Return the module name for a directory. The directory is converted to a
--- module name by removing the all untill the last `lua/` and replacing the
--- remaining `/` with `.`. The last `/` is removed.
---@param dir string directory to convert to a module name.
---@return string module
M.dir_to_module = function(dir)
    local relative_dir = dir:gsub(".*" .. M.path_separator .. "lua" .. M.path_separator, "")
    return relative_dir:gsub(M.path_separator, "."):sub(1, -2)
end

--- Similar to `join`, but now for module names, which are separated by a dot.
---@param module string The module name. For example `helpers`.
---@vararg string The parts of the module name to join. For example `path` and
--join
---@return string module The joined module name. For example
--`helpers.path.join`.
M.module_join = function(module, ...)
    local parts = { ... }
    return module .. "." .. table.concat(parts, ".")
end

--- Checks if a file exists.
---@param filename string The name of the file to be checked.
---@return boolean result True if the file exists, false otherwise.
M.exists = function(filename)
    filename = vim.fn.expand(filename)
    return vim.fn.filereadable(filename) == 1
end

--- Normalize a path.
--- I hate windows separators...
--- @param path string The path to normalize.
--- @return string The normalized path.
M.norm = function(path)
    return path:gsub("\\", "/")
end

--- Return top level directory of a path.
---@param path string The path to get the top level directory from.
---@return string The top level directory.
M.top_dir = function(path)
    return M.norm(vim.fn.fnamemodify(path, ":p:h")):match("([^/]+)$")
end

return M
