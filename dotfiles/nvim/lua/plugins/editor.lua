return {
    '907th/vim-auto-save',
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-obsession',
    'junegunn/vim-peekaboo',
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup()
        end
    }
}
