return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        event = 'VeryLazy',
        config = function()
            require('config.treesitter')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'VeryLazy',
        config = function()
            require('config.treesitter-context')
        end,
    }
}
