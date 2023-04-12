-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 0

local tree = require('nvim-tree')
local keymapper = require('keymapper')

local my_mappings = {
    { key = "u",    action = "dir_up" },
    { key = "<BS>", action = "" },
    { key = "<CR>", action = "" },
    { key = "x",    action = "close_node" },
}

tree.setup({
    sort_by = "name",
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    view = {
        width = { max = 30, padding = 0 },
        mappings = { list = my_mappings, },
        relativenumber = true,
        signcolumn = "no"
    },
    renderer = { group_empty = true },
    filters = { dotfiles = false },
    git = { ignore = false },
    experimental = {
        git = {
            async = true,
        }
    }
})

keymapper.noremap('<a-X>', '<cmd>NvimTreeFindFile<CR>')
keymapper.noremap('<a-x>', '<cmd>NvimTreeToggle<CR>')
