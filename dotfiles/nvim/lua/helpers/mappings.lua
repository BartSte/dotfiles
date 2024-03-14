local M = {}

M.highlight_word = function()
    local current_word = vim.fn.expand('<cword>')
    if current_word ~= '' then
        vim.fn.setreg('/', '\\V\\<' .. vim.fn.escape(current_word, '\\') .. '\\>')
        vim.cmd('set hlsearch')
    end
end

return M
