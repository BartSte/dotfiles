--- When using a global mark, the following will be appended to the command:
--      {symbol}"
--  For example, if we set symbol to `symbol='`, after calling a global mark
--  `A`, the following command is triggered:
--      'A'"
--  As, a result the cursor is returned to the last position ('") instead of the
--  mark.
--
---@param symbol string
local function jump_with(symbol)
    print("Waiting for mark...")

    local mark = vim.fn.nr2char(vim.fn.getchar())
    local command = symbol .. mark

    if mark == string.upper(mark) then
        command = command .. symbol .. '"'
    end

    print(command)
    vim.api.nvim_feedkeys(command, 'n', false)
end

--- returns a function handle for `jump_with` where symbol is: '
---@return function
local function last_position()
    return function() jump_with("'") end
end

--- returns a function handle for `jump_with` where symbol is: `
---@return function
local function last_col_position()
    return function() jump_with('`') end
end

vim.keymap.set('n', "'", last_position(), { expr = true, noremap = false })
vim.keymap.set('n', "`", last_col_position(), { expr = true, noremap = false })
