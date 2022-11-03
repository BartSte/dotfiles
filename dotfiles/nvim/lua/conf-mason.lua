local mason = require('mason')
local lsp = require("mason-lspconfig")
local registry = require('mason-registry')

local function ensure_installed(formatters)
    for _, x in pairs(formatters) do
        if not registry.is_installed(x) then
            vim.cmd('MasonInstall {x}')
        end
    end
end

mason.setup()
lsp.setup({
    ensure_installed = { "sumneko_lua", "pyright" }
})

local formatters = { 'autopep8' }

ensure_installed(formatters)
