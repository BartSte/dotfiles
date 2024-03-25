local function on_attach(client, bufnr)
    if client.name == 'ruff_lsp' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end
end

require('lspconfig').ruff_lsp.setup({
    on_attach = on_attach
})

