local mason = require('mason')
local lsp = require("mason-lspconfig")
local registry = require('mason-registry')

local function ensure_installed(formatters)
    for _, x in pairs(formatters) do
        if not registry.is_installed(x) then
            vim.cmd(string.format('MasonInstall %s', x))
        end
    end
end

local servers = { "sumneko_lua", "pyright", "vimls", "bashls", "jsonls", "clangd", "cssls", "arduino_language_server",
    "powershell_es", "marksman" }
local formatters = { 'autopep8' }

mason.setup()
lsp.setup({ ensure_installed = servers })
ensure_installed(formatters)
