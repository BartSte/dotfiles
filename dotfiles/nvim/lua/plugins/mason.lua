return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require('config.mason')
        end
    },
    'jay-babu/mason-nvim-dap.nvim',
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
}
