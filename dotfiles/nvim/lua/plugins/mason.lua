return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    event = { "BufReadPost", "BufNewFile" },
    build = ":MasonUpdate",
    config = function()
        require('config.mason')
    end,
    dependencies = {
        'jay-babu/mason-nvim-dap.nvim',
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
    }
}
