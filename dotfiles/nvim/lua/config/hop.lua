local hop = require('hop')
local func = require('helpers.hop')

hop.setup({
    keys = 'rlaodhgmfiwypu;cx/jbvsetn',
    jump_on_sole_occurrence = true,
    uppercase_labels = true,
    multi_windows = false
})

vim.keymap.set('', 'S', func.hop_char1)

vim.keymap.set('', 'j', func.hop_b, { noremap = true })
vim.keymap.set('', 'J', func.hop_B, { noremap = true })
vim.keymap.set('', 'l', func.hop_ge, { noremap = true })
vim.keymap.set('', 'L', func.hop_gE, { noremap = true })

vim.keymap.set('', 'k', func.hop_w, { noremap = true })
vim.keymap.set('', 'K', func.hop_W, { noremap = true })
vim.keymap.set('', 'h', func.hop_e, { noremap = true })
vim.keymap.set('', 'H', func.hop_E, { noremap = true })
