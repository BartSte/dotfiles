---@class LuaLine
---@field tabs function
---@field venv function
---@field shada function
---@field marks function
---@field mark_exists function
---@field find_marks function
---@field extract_venv_name function
---@return LuaLine
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
    return extract_venv_name(vim.env.VIRTUAL_ENV)
end

M.shada = function()
    if vim.go.shadafile == "" then
        return "🌍"
    else
        return "💾"
    end
end

--- Runs the `marks` with
---@param args string|nil The arguments to pass to the marks command
---@return table marks The marks of the current buffer
local function get_marks(args)
    args = args or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local ok, result = pcall(vim.fn.execute, "marks " .. args)
    if ok then
        return vim.split(result, "\n")
    else
        return {}
    end
end

--- Return true if the mark exists in the buffer. Otherwise, return false.
---@param bufnr number The buffer number
---@param mark string The mark to check
---@return boolean
local function mark_in_buffer(bufnr, mark)
    local row_col = vim.api.nvim_buf_get_mark(bufnr, mark)
    return row_col[1] + row_col[2] > 0
end

--- Return a table of marks that exist in the buffer.
---@param bufnr number The buffer number
---@return table<string> marks The marks that exist in the buffer
local function find_marks(bufnr)
    local marks = {}
    for _, line in ipairs(get_marks()) do
        local mark = line:match("^ *([a-zA-Z]) ")
        if mark ~= nil and mark_in_buffer(bufnr, mark) then
            table.insert(marks, mark)
        end
    end
    return marks
end

local latest_buffer = 0
local latest_marks = ""
--- Return the lowercase and uppercase marks of the current buffer.
---@return string marks The marks of the current buffer
M.marks = function()
    local buffer = vim.fn.bufnr()
    if buffer ~= latest_buffer then
        latest_buffer = buffer
        latest_marks = table.concat(find_marks(buffer), " ")
    end
    return latest_marks
end

--- Add a mark and then triggers an update for the marks function.
M.add_mark = function()
    local msg = require("projectmarks").opts.message
    vim.api.nvim_notify(msg, vim.log.levels.INFO, {})
    local ok, result = pcall(vim.fn.getchar)
    vim.api.nvim_notify('', vim.log.levels.INFO, {})
    vim.api.nvim_command('redraw')

    if ok then
        vim.cmd("normal! m" .. result)
    end

    latest_buffer = 0
end

--- Delete a mark and then triggers an update for the marks function.
---@param mark string The mark to delete
M.delete_mark = function(mark)
    vim.cmd("delmarks " .. mark)
    latest_buffer = 0
end

return M
