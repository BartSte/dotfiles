return {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.treesitter-context')
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter'
    }
}
