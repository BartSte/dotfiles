local keymapper = require('helpers.keymapper')

vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

keymapper.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

local config = {
    justMyCode = true,
    subProcess = false,
}

if vim.g.dap_python_loaded then
    local dappy = require('dap-python')
    keymapper.buffer_nnoremap('<a-C>', function() dappy.test_class({ config }) end)
    keymapper.buffer_nnoremap('<a-T>', function() dappy.test_method({ config }) end)
    keymapper.buffer_nnoremap('<a-S>', function() dappy.test_selection({ config }) end)
end
