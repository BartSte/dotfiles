-- Checkout the README.md for information how the configuration is organized.
vim.g.mapleader = ' '
require('helpers.lazy').bootstrap()
require('lazy').setup('plugins', {
      change_detection = {
        enabled = false,
        notify = true, -- get a notification when changes are found
}})
