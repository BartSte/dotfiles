return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    run = ':TSUpdate',
    config = function()
        require('config.treesitter')
    end,
    build = ':TSUpdate',
}
