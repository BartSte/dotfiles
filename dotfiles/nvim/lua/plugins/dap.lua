return {
    'mfussenegger/nvim-dap',
    keys = { '<F5>', '<cmd>DapContinue<CR>' },
    dependencies = {
        'hrsh7th/nvim-cmp',
        'rcarriga/cmp-dap',
        "williamboman/mason.nvim",
        {
            'jay-babu/mason-nvim-dap.nvim',
            config = function()
                require('mason-nvim-dap').setup({ automatic_installation = false })
            end
        },
        {
            'theHamsta/nvim-dap-virtual-text',
            config = function() require('config.dap-virtual-text') end,
        },
    }
}
