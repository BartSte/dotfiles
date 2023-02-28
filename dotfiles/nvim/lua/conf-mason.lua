local mason = require('mason')
local lsp = require("mason-lspconfig")
local null = require('mason-null-ls')
local mason_dap = require('mason-nvim-dap')

local servers = { "pyright", "vimls", "bashls", "jsonls", "clangd", "cssls", "arduino_language_server", "marksman" }
local formatters_and_linters = { 'autopep8', 'ruff' }

mason.setup()
mason_dap.setup({ ensure_installed = { "python" }, automatic_setup = true})
mason_dap.setup_handlers({})

lsp.setup({ ensure_installed = servers })
null.setup({ ensure_installed = formatters_and_linters })
