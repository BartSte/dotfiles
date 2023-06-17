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
    { "williamboman/mason.nvim",           build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
    { "jay-babu/mason-null-ls.nvim",       dependencies = { "williamboman/mason.nvim" } },

    --Looks
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require("config-treesitter") end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function() require('config-treesitter-context') end
    },
    'nvim-lualine/lualine.nvim',
    { 'luisiacc/gruvbox-baby', branch = 'main' },

    --Lsp
    {
        "folke/neodev.nvim",
        ft = "lua",
        config = function() require("config-neodev") end
    },
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
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
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
    { 'nvim-orgmode/orgmode', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
    { 'BartSte/nvim-khalorg', dependencies = { 'nvim-orgmode/orgmode' } },
    'dhruvasagar/vim-table-mode',

    --Markdown
    {
        "iamcco/markdown-preview.nvim",
        ft = 'markdown',
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function() vim.cmd("so ~/dotfiles/nvim/vim/config-markdown.vim") end
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
