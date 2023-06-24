return {
    {
        'christoomey/vim-tmux-navigator',
        event = 'VeryLazy',
        config = function()
            vim.cmd('runtime vim/tmux-navigator.vim')
        end
    },
    {
        'moll/vim-bbye',
        keys = {
            { '<space>q', '<cmd>Bdelete<cr>' }
        },
    },
    {
        'BartSte/hop.nvim',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('config.hop')
        end
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('config.oil')
        end
    }
}
