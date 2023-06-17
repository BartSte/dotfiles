return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        -- Treesitter is sourced in /plugins/ to ensure it is loaded before other plugins
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('config.treesitter-context')
        end,
    }
}
