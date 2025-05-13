local servers= require('config.lsp.servers')

require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = false
})
