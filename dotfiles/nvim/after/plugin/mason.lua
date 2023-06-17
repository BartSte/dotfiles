local dap = require('mason-nvim-dap')
local lsp = require("mason-lspconfig")
local null = require('mason-null-ls')
local mason = require('mason')

mason.setup()

-- Toggle to true if you want to install the plugins that are initialized within the config.
dap.setup({automatic_installation = false})
lsp.setup({automatic_installation = false})
null.setup({automatic_installation = false})
