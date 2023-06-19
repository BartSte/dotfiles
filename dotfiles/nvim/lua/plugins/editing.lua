return {
    {
        'tpope/vim-commentary',
        event = 'VeryLazy',

    },
    {
        'tpope/vim-surround',
        event = 'VeryLazy',

    },
    {
        'tpope/vim-obsession',
        lazy = false,
    },
    {
        '907th/vim-auto-save',
        lazy = false,
        config = function()
            vim.cmd('runtime vim/auto-save.vim')
        end
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
