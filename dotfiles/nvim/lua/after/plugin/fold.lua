local M = {}

function FoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local number_of_lines = vim.v.foldend - vim.v.foldstart
    local fill_count = vim.fn.winwidth('%') - #line - #tostring(number_of_lines) - 14
    return line .. ' ' .. string.rep('.', fill_count) .. ' (' .. number_of_lines .. ' L)'
end

M.setup = function()
    vim.cmd('set foldtext=v:lua.FoldText()')
    vim.cmd('set fillchars=fold:\\ ')
end

return M
