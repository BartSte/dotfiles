local lsp_defaults = require('lspconfig').util.default_config
local helpers = require("helpers.lsp")
local mappings = require('config.lsp.mappings')
local servers = require('config.lsp.servers')

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(args)
        mappings.setup(args)
        helpers.notify.attach(args)
    end,
})

vim.api.nvim_create_autocmd("LspProgress", { callback = helpers.notify.progress })

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = { border = 'rounded', },
})

-- TODO: when opening the first buffer, ruff + null-ls are both loaded for
-- winpyproject. Later, only null-ls is loaded (as expected).
servers.setup()

