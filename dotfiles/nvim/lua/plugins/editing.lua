return {
    {
        'git-time-metric/gtm-vim-plugin',
        lazy = false,
    },
    {
        'tpope/vim-commentary',
        lazy = false,
    },
    {
        'tpope/vim-surround',
        lazy = false,
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
