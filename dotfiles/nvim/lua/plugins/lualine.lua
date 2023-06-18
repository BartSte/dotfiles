return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
        require('config.lualine')
    end
}
