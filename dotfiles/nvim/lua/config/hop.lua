local hop = require('hop')
local func = require('helpers.hop')

hop.setup({
    keys = 'rlaodhgmfiwypu;cx/jbvsetn',
    jump_on_sole_occurrence = true,
    uppercase_labels = true,
    multi_windows = false
})

local o = { "o" }
local nx = { "n", "x" }
local nxo = { "n", "x", "o" }
vim.keymap.set(nxo, 'S', func.hop_char1)

vim.keymap.set(nxo, 'j', func.hop_b, { noremap = true })
vim.keymap.set(nxo, 'J', func.hop_B, { noremap = true })
vim.keymap.set(nx, 'l', func.hop_ge, { noremap = true })
vim.keymap.set(nx, 'L', func.hop_gE, { noremap = true })

vim.keymap.set(nx, 'k', func.hop_w, { noremap = true })
vim.keymap.set(nx, 'K', func.hop_W, { noremap = true })
vim.keymap.set(nxo, 'h', func.hop_e, { noremap = true })
vim.keymap.set(nxo, 'H', func.hop_E, { noremap = true })

-- hop_w and hop_W their offset needs to be adjusted when used
-- with operator pending mode. Could well be that some others have the same
-- issue.
vim.keymap.set(o, 'k', func.hop_wo, { noremap = true })
vim.keymap.set(o, 'K', func.hop_Wo, { noremap = true })
