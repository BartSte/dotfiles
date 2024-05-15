require('lspconfig').ruff_lsp.setup({
    on_attach = require('helpers.lsp').format_with_client(
        "null-ls",
        "<leader>f"
    )
})
