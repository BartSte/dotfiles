require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_filter(function(server)
        return server ~= "kmp_lsp"
    end, vim.tbl_keys(require('config.lsp.servers'))),
    automatic_enable = false
})
