local keymapper = require('helpers.keymapper')

local M = {}

local function mappings()
    keymapper.nnoremap('<a-t>', ':GTestRunUnderCursor<CR>')
end

M.setup = function()
    mappings()
    vim.cmd('let g:gtest#gtest_command = "build/tests"')
end

return M
