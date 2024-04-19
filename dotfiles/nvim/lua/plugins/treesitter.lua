return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
        require('config.treesitter')
    end,
    build = ':TSUpdate',
}
