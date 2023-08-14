return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = require('config.todo-comments').config
    },
    {
        'tpope/vim-obsession',
        lazy = false,
        config = function()
            vim.cmd('runtime vim/obsession.vim')
        end
    },
    {
        '907th/vim-auto-save',
        lazy = false,
    },
    {
        'tpope/vim-commentary',
        event = 'VeryLazy',
    },
    {
        'tpope/vim-surround',
        event = 'VeryLazy',
    },
    {
        'junegunn/vim-peekaboo',
        event = 'VeryLazy',
        config = function()
            vim.cmd('runtime vim/peekaboo.vim')
        end
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = require('config.autopairs').setup
    }
}
