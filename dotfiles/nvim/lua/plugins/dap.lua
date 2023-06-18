return {
    'mfussenegger/nvim-dap',
    keys = { '<F5>', '<cmd>DapContinue<CR>' },
    dependencies = {
        -- Dap python was replaced by ipdb
        --         {
        --             'mfussenegger/nvim-dap-python',
        --             config = function() require('config.dap') end,
        --         },
        {
            'theHamsta/nvim-dap-virtual-text',
            config = function() require('config.dap-virtual-text') end,
        },
        {
            {
                {
                    'jay-babu/mason-nvim-dap.nvim',
                    config = function()
                        require('mason-nvim-dap').setup({ automatic_installation = false })
                    end
                },
                'rcarriga/cmp-dap',
                dependencies = {
                    'hrsh7th/nvim-cmp',
                },
            },
        }
    }
}
