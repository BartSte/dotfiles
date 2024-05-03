---@class LuaLine
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

--- Return true if the mark exists in the buffer. Otherwise, return false.
---@param bufnr number The buffer number
---@param mark string|nil The mark to check
---@return boolean
local function mark_exists(bufnr, mark)
    if mark == nil then
        return false
    end
    local row_col = vim.api.nvim_buf_get_mark(bufnr, mark)
    return row_col[1] + row_col[2] > 0
end

local function find_marks(bufnr)
    local marks = {}
    local marks_list = vim.fn.execute("marks")
    local marks_table = vim.split(marks_list, "\n")
    for _, line in ipairs(marks_table) do
        local mark = line:match("^ *([a-zA-Z])")
        if mark_exists(bufnr, mark) then
            table.insert(marks, mark)
        end
    end
    return marks
end

--- Return the lowercase and uppercase marks of the current buffer.
---@return string marks The marks of the current buffer
M.marks = function()
    return table.concat(find_marks(0), " ")
end

return M
