return {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    config = function()
        require('config.cmp')
    end,
    dependencies = {
        'dmitmel/cmp-cmdline-history',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'rcarriga/cmp-dap',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
    }
}
