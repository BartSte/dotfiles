local keymapper = require('keymapper')
local tree = require('nvim-tree')

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

local my_mappings = {
    { key = "u", action = "dir_up" },
    { key = "<BS>", action = "" },
    { key = "<CR>", action = "" },
    { key = "x", action = "close_node" },
}

tree.setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = { list = my_mappings, },
        relativenumber = true,
        signcolumn = 'no',
    },
    renderer = { group_empty = true, },
    filters = { dotfiles = false, },
    git = { ignore = false }
})

keymapper.noremap('<a-X>', '<cmd>NvimTreeFindFile<CR>')
keymapper.noremap('<a-x>', '<cmd>NvimTreeToggle<CR>')
