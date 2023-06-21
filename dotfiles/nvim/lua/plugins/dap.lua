return {
    'mfussenegger/nvim-dap',
    keys = {
        { '<F5>', '<cmd>DapContinue<CR>' },
        { '<F9>', '<cmd>DapBreakPoint<CR>'}
    },
    config = function()
        require('config.dap')
    end,
    dependencies = {
        'hrsh7th/nvim-cmp',
        'rcarriga/cmp-dap',
        "williamboman/mason.nvim",
        'mfussenegger/nvim-dap-python',
        {
            'jay-babu/mason-nvim-dap.nvim',
            config = function()
                require('mason-nvim-dap').setup({ automatic_installation = true })
            end
        },
        {
            'theHamsta/nvim-dap-virtual-text',
            config = function() require('config.dap-virtual-text') end,
        },
    }
}
