local dappy = require('dap-python')

vim.opt_local.conceallevel = 2
vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

local opts = {
    config = {
        justMyCode = true,
        subProcess = false,
    }
}
vim.keymap.set('n', '<a-C>', function() dappy.test_class(opts) end)
vim.keymap.set('n', '<a-T>', function() dappy.test_method(opts) end)
vim.keymap.set('n', '<a-S>', function() dappy.test_selection(opts) end)


-- require("vim.lsp.utils").format { timeout_ms = 2000 }
