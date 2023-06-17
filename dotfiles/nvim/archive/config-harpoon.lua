local harpoon = require('harpoon')
local keymapper = require('helpers.keymapper') 

harpoon.setup({
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = true,
    tmux_autoclose_windows = false,
    excluded_filetypes = { "harpoon" },
    mark_branch = false,
})

keymapper.nnoremap('<a-q>', ':lua require("harpoon.term").gotoTerminal(1)<CR>')
