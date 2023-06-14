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

local plugins = {
    --Helpers
    'nvim-lua/plenary.nvim',

    --Package managers
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",

    --Looks
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-lualine/lualine.nvim',
    { 'luisiacc/gruvbox-baby', branch = 'main' },

    --Lsp
    "folke/neodev.nvim",
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',

    --Completion
    "danymat/neogen",
    'dmitmel/cmp-cmdline-history',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'rcarriga/cmp-dap',
    {
        'zbirenbaum/copilot.lua',
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("config-copilot")
        end,
    },

    --Navigation
    { 'junegunn/fzf',          build = ':call fzf#install()' },
    { 'junegunn/fzf.vim',      dependencies = { 'junegunn/fzf' } },
    'junegunn/vim-peekaboo',
    'moll/vim-bbye',
    'stevearc/oil.nvim',
    'BartSte/hop.nvim',

    --Editing
    '907th/vim-auto-save',
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-obsession',
    'tpope/vim-scriptease',
    'windwp/nvim-autopairs',

    --Git
    'tpope/vim-fugitive',
    'junegunn/gv.vim',

    --Test/Debug
    'vim-test/vim-test',
    'jgdavey/tslime.vim',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',

    --Org
    'nvim-orgmode/orgmode',
    'BartSte/nvim-khalorg',
    'dhruvasagar/vim-table-mode',

    --Markdown
    { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end }
}

local opts = {}

require("lazy").setup(plugins, opts)
