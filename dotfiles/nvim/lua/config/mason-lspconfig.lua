require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(require('config.lsp.servers')),
    automatic_enable = false
})
