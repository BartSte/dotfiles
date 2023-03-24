local dap = require('mason-nvim-dap')
local lsp = require("mason-lspconfig")
local null = require('mason-null-ls')
local mason = require('mason')

local servers = { "pyright", "vimls", "bashls", "jsonls", "clangd", "cssls", "arduino_language_server"}
local debuggers = { "python" }
local formatters_and_linters = { 'autopep8', 'ruff' }

mason.setup()
dap.setup({ ensure_installed = debuggers })
lsp.setup({ ensure_installed = servers })
null.setup({ ensure_installed = formatters_and_linters })
