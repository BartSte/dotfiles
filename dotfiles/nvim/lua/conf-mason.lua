local mason = require('mason')
local lsp = require("mason-lspconfig")
local null = require('mason-null-ls')
local mason_dap = require('mason-nvim-dap')

local servers = { "pyright", "vimls", "bashls", "jsonls", "clangd", "cssls", "arduino_language_server", "marksman" }
local formatters_and_linters = { 'autopep8', 'ruff' }

mason.setup()
mason_dap.setup({ automatic_installation = true })
lsp.setup({ ensure_installed = servers })
null.setup({ ensure_installed = formatters_and_linters })
