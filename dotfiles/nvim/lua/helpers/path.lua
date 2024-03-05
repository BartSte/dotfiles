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

M.home = function()
    if vim.fn.has('win32') == 1 then
        return os.getenv('USERPROFILE')
    else
        return os.getenv('HOME')
    end
end

--- For org + wsl, windows $USERPROFILE is used as home and is captured by the
--environment variable $WH (Windows Home).
M.dropbox_home = function()
    local wsl_home = os.getenv('WH')
    if (wsl_home) then
        return wsl_home
    elseif vim.fn.has('win32') == 1 then
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
    exclude = exclude or "/init$"
    local path = require("helpers.path")
    local include = path.join(directory, "*.lua")

    local modules = {}
    local files = vim.fn.glob(include, false, true)
    for _, file in ipairs(files) do
        local lua_file = file:match('lua/(.*)%.lua')
        if not lua_file:match(exclude) then
            local module = lua_file:gsub(path.path_separator, ".")
            modules[#modules + 1] = module
        end
    end

    return modules
end

M.file = function(level)
    level = level or 2
    return debug.getinfo(level, "S").source:sub(2)
end

M.dir = function(level)
    level = level or 2
    -- debug needs to be called here explicitly in order to keep the same
    -- default call stack level as the other functions of 1.
    local file = debug.getinfo(level, "S").source:sub(2)
    return file:match("(.*/)") or file:match("(.*/)")
end

M.module = function(level)
    level = level or 2
    -- debug needs to be called here explicitly in order to keep the same
    -- default call stack level as the other functions of 2.
    local file = debug.getinfo(level, "S").source:sub(2)
    local dir = file:match("(.*/)") or file:match("(.*/)")
    local relative_dir = dir:gsub(".*/lua/", "")
    return relative_dir:gsub("/", "."):sub(1, -2)
end

return M
