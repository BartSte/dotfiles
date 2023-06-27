return {
    {
        'BartSte/nvim-project-marks',
        config = function()
            require('projectmarks').setup({})
        end
    },
    {
        'git-time-metric/gtm-vim-plugin',
        cond = function()
            return vim.fn.executable('gtm') == 1
        end
    },
    {
        'tpope/vim-obsession',
        lazy = false,
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
