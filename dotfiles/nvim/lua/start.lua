local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {  change_detection = { enabled = false }})

require('linux')
require('config-hop')
require('config-lualine')
require('config-lsp-init')
require('config-lsp-servers')
require('config-lsp-mappings')
require('config-null-ls')
require('config-cmp')
require('config-nvim-dap')
require('config-nvim-dap-virtual-text')
require('config-mason')
require('config-autopairs')
require('config-neogen')
require('config-orgmode')
require('config-oil')

require('local-shada')
require('global-marks')
require('autocmds')
