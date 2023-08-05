return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('config.treesitter')
        end,
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('config.treesitter-context')
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
            }
    }
}
