---@class Helpers.LuaLine
--- Module providing custom components for lualine statusline.
---@field tabs fun(): string Gets formatted current/total tab information
---@field venv fun(): string|nil Retrieves Python virtual environment name
local M = {}

--- Gets current tab position and total tabs as formatted string
---@return string tab_info Formatted "tab X/Y" string where X is current tab, Y is total tabs
M.tabs = function()
    local current_tab = vim.fn.tabpagenr()
    local number_of_tabs = vim.fn.tabpagenr("$")
    return "tab " .. string.format("%d/%d", current_tab, number_of_tabs)
end

--- Recursively extracts virtual environment name from path
---@param venv string|nil Path to virtual environment
---@param exclude? string[] Names to exclude from detection (default: venv/.venv)
---@return string|nil name Extracted environment name or nil if no valid name found
local function extract_venv_name(venv, exclude)
    if not venv then
        return nil
    end
    exclude = exclude or { "venv", ".venv" }
    venv = string.gsub(venv, "\\", "/")
    local name = string.match(venv, "/([^/]*)$")
    if vim.tbl_contains(exclude, name) then
        local new_venv = string.match(venv, "^(.*)/[^/]*$")
        return extract_venv_name(new_venv, exclude)
    else
        return name
    end
end

--- Gets Python virtual environment name from VIRTUAL_ENV variable
---@return string|nil name Current venv name or nil if not in Python virtualenv
M.venv = function()
    return extract_venv_name(vim.env.VIRTUAL_ENV)
end

return M
