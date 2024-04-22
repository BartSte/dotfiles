return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
        require('config.lualine')
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
}
