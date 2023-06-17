return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('config.treesitter-init')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('config.treesitter-context')
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        }
    }
}
