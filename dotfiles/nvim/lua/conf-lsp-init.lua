local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local cmp_nvim_lsp = require('cmp_nvim_lsp')

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    cmp_nvim_lsp.default_capabilities()
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { update_in_insert = false }
)
