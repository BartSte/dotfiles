local M = {}

---Run a vim.cmd named `cmd`. After that, the cursor position is restored.
---@param cmd string
M.keep_position = function(cmd)
    local cursor = vim.fn.getpos('.')
    if cursor == nil then
        vim.notify('Cursor position not found', vim.log.levels.ERROR)
    else
        vim.cmd(cmd)
        vim.fn.setpos('.', cursor)
    end
end

return M
