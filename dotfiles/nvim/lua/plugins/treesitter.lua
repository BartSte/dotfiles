return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        run = ':TSUpdate',
        config = function()
            require('config.treesitter')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('config.treesitter-context')
        end,
    }
}
