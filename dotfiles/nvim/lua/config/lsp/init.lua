local lsp_defaults = require('lspconfig').util.default_config
local helpers = require("helpers.lsp")
local mappings = require('config.lsp.mappings')

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = 'rounded',
    },
})

require('config.lsp.servers')

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(args)
        mappings.set(args)
        helpers.notify.attach(args)
    end,
})
vim.api.nvim_create_autocmd("LspProgress", { callback = helpers.notify.progress })
