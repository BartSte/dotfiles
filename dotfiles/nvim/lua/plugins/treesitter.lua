return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.treesitter')
    end,
    build = ':TSUpdate',
}
