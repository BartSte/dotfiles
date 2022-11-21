local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})
lspconfig.vimls.setup({})
lspconfig.bashls.setup({})
lspconfig.jsonls.setup({})
lspconfig.clangd.setup({})
lspconfig.cssls.setup({})
lspconfig.cmake.setup({})

lspconfig.sumneko_lua.setup({
    single_file_support = true,
    flags = { debounce_text_changes = 150 },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
