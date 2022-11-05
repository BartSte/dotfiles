local harpoon = require('harpoon')
local ui = require('harpoon.ui')
local mark = require('harpoon.mark')
local mapper = require('keymapper')

harpoon.setup({
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = false,
    tmux_autoclose_windows = false,
    excluded_filetypes = { "harpoon" },
    mark_branch = false,
})

local function nav_file(number)
    return function ()
       ui.nav_file(number)
    end
end

mapper.nnoremap('<a-H>', ui.toggle_quick_menu)
mapper.nnoremap('<leader>h', mark.add_file)
mapper.nnoremap("g1", nav_file(1))
mapper.nnoremap("g2", nav_file(2))
mapper.nnoremap("g3", nav_file(3))
mapper.nnoremap("g4", nav_file(4))
mapper.nnoremap("g5", nav_file(5))
mapper.nnoremap("g6", nav_file(6))
