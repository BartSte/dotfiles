local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})
lspconfig.vimls.setup({})
lspconfig.bashls.setup({})
lspconfig.jsonls.setup({})
lspconfig.cssls.setup({})
lspconfig.cmake.setup({})
lspconfig.powershell_es.setup({})
lspconfig.marksman.setup({})

lspconfig.clangd.setup({})
-- lspconfig.arduino_language_server.setup {
--     cmd = {
--         "arduino-language-server",
--         "-cli-config", "~/.arduino15/arduino-cli.yaml",
--         "-fqbn", "keyboardio:avr:keyboardio_atreus",
--         "-cli", "arduino-cli",
--         "-clangd", "clangd"
--     },
--     filetypes = { "arduino", "cpp" }
-- }

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
