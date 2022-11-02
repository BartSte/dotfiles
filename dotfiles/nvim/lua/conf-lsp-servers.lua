local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})

lspconfig.sumneko_lua.setup({
    single_file_support = true,
    flags = {
        debounce_text_changes = 150,
    },
    Lua = {
        diagnostics = {
            globals = { "vim" },
        },
    },
})
