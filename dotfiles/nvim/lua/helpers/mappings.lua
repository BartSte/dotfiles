local M = {}

M.highlight_word = function()
    local current_word = vim.fn.expand('<cword>')
    if current_word ~= '' then
        vim.fn.setreg('/', '\\V\\<' .. vim.fn.escape(current_word, '\\') .. '\\>')
        vim.cmd('set hlsearch')
    end
end

--- Runs `gggqG` on the current buffer before returning the cursor to its
--- original position.
---@return nil
function M.gggqG()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! gggqG")
    vim.api.nvim_win_set_cursor(0, pos)
end


return M
