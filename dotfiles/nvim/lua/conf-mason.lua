local mason = require('mason')
local lsp = require("mason-lspconfig")
local null = require('mason-null-ls')

local servers = { "sumneko_lua", "pyright", "vimls", "bashls", "jsonls", "clangd", "cssls", "arduino_language_server",
    "marksman" }
local formatters_and_linters = { 'autopep8', 'ruff' }

mason.setup()
lsp.setup({ ensure_installed = servers })
null.setup({ ensure_installed = formatters_and_linters })
