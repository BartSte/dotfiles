local M = {}

M.setup = function()
    vim.cmd('let g:gtest#gtest_command = "build/bin/tests"')
end

return M
