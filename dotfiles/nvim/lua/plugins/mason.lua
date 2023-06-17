return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require('config.mason')
        end
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        lazy = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        lazy = true,
    },
}
