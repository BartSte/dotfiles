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
    local nxo = { "n", "x", "o" }
    local nmap = { noremap = true }

    vim.keymap.set(nxo, 'S', func.hop_char1)
    vim.keymap.set(nxo, 'h', func.hop_bgewe, nmap)
    vim.keymap.set(nxo, 'H', func.hop_BgEWE, nmap)
end

hop.setup(opts)
set_mappings()
