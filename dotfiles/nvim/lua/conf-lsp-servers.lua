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

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "2"
                }

            }
        },
    },
}
