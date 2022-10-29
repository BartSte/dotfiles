-- local func = require('functions')
local tree = require('nvim-tree')

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
tree.setup()

-- OR setup with some options
tree.setup({
  sort_by = "case_sensitive",
  view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
        relativenumber = true,
        signcolumn = 'no',
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

