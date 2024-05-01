local devicons = require("nvim-web-devicons")

---@class LuaLine
---@field tabs function()
---@field venv function()
---@field shada function()
local M = {}

--- Return the current tab number and the total number of tabs.
---@return string tab_number/total_tabs
M.tabs = function()
    local current_tab = vim.fn.tabpagenr()
    local number_of_tabs = vim.fn.tabpagenr("$")
    return "tab " .. string.format("%d/%d", current_tab, number_of_tabs)
end

--- Extract the virtual environment name from the VIRTUAL_ENV environment.
--
--- If the virtual environment name is in the exclude list, it will be removed
--- from the path and the next directory will be checked.
---@param venv string The virtual environment path
---@param exclude table<string>|nil A list of names to exclude
local function extract_venv_name(venv, exclude)
    exclude = exclude or { "venv", ".venv" }
    local name = string.match(venv, "/([^/]*)$")
    if vim.tbl_contains(exclude, name) then
        local new_venv = string.match(venv, "^(.*)/[^/]*$")
        return extract_venv_name(new_venv, exclude)
    else
        return name
    end
end

--- Return the current virtual environment name with an icon if it exists, and
--- the current file type is python.
---@return string name virtualenv_name
M.venv = function()
    local is_python = vim.bo.filetype == "python"
    if vim.env.VIRTUAL_ENV and is_python then
        return extract_venv_name(vim.env.VIRTUAL_ENV)
    else
        return ""
    end
end

M.shada = function()
    return string.match(vim.o.shadafile, "/([^/]*)$")
end

return M
