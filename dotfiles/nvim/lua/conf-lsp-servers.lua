local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})
lspconfig.vimls.setup({})
lspconfig.bashls.setup({})
lspconfig.jsonls.setup({})
lspconfig.cssls.setup({})
lspconfig.cmake.setup({})
lspconfig.powershell_es.setup({})
lspconfig.marksman.setup({})

-- lspconfig.clangd.setup({})
lspconfig.arduino_language_server.setup {
    cmd = {
        "arduino-language-server",
        "-cli-config", "~/.arduino15/arduino-cli.yaml",
        "-fqbn", "keyboardio:avr:keyboardio_atreus",
        "-cli", "arduino-cli",
        "-clangd", "clangd"
    },
    filetypes = { "arduino", "cpp" }
}

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
