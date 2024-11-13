local M = {}

M.lensort = {}
M.lensort.arg = nil
M.lensort.func = function(type)
    vim.cmd("'[,']!lensort " .. M.lensort.arg)
end

M.charsort = function(type)
    vim.cmd("'[,']sort")
end

return M
