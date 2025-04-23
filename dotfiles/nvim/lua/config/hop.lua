local hop = require('hop')
local func = require('helpers.hop')

local opts = {
    keys = 'rlaodhgmfiwypu;cx/jbvsetn',
    jump_on_sole_occurrence = true,
    uppercase_labels = true,
    multi_windows = false
}

local function foo()
end
local function set_mappings()
    local o = { "o" }
    local nx = { "n", "x" }
    local nxo = { "n", "x", "o" }
    local nmap = { noremap = true }

    vim.keymap.set(nxo, 'S', func.hop_char1)

    vim.keymap.set(nxo, 'h', func.hop_e, nmap)
    vim.keymap.set(nxo, 'H', func.hop_E, nmap)
    vim.keymap.set(nxo, 'j', func.hop_b, nmap)
    vim.keymap.set(nxo, 'J', func.hop_B, nmap)
    vim.keymap.set(nxo, 'l', func.hop_ge, nmap)
    vim.keymap.set(nxo, 'L', func.hop_gE, nmap)

    -- hop_w and hop_W their offset needs to be adjusted when used
    -- with operator pending mode. Could well be that some others have the same
    -- issue.
    vim.keymap.set(nx, 'k', func.hop_w, nmap)
    vim.keymap.set(o, 'k', func.hop_wo, nmap)
    vim.keymap.set(nx, 'K', func.hop_W, nmap)
    vim.keymap.set(o, 'K', func.hop_Wo, nmap)
end

hop.setup(opts)
set_mappings()
