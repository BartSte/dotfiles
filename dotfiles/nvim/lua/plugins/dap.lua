return {
    'mfussenegger/nvim-dap',
    keys = { '<F5>', '<cmd>DapContinue<CR>' },
    dependencies = {
        {
            'mfussenegger/nvim-dap-python',
            config = function() require('config.dap') end,
        },
        {
            'theHamsta/nvim-dap-virtual-text',
            config = function() require('config.dap-virtual-text') end,
        },
    }
}
