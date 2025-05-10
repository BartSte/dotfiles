local fn = require("helpers.fn")
local lsp = require('lspconfig')
local helpers = require("helpers.lsp")
local mappings = require('config.lsp.mappings')
local server_opts = require('config.lsp.servers')
local capabilities = require('config.lsp.capabilities')
local lsp_defaults = require('lspconfig').util.default_config

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
    float = { border = 'rounded' },
})

---The on_attach function can be used to setup configurations that are specific
---to a server. Server capabilities can be specified in the capabilities module.
---Here, a decorator is used to update the capabilities of all servers. If the
---server is not specified in the capabilities module, no changes are made.
<<<<<<< HEAD
for server, config in pairs(server_opts) do
    --TODO: the on_attach hook is not called for each new buffer. Only for each new client. Only null-ls is created for eacht new buffer. I gues this behavior changed?

=======
for name, config in pairs(server_opts) do
>>>>>>> 14e5a1a2c7a4af59c54a5e844ceb9b2c9a6f53dd
    config.on_attach = fn.decorate({
        capabilities.update,
        mappings.on_lsp_attach,
        config.on_attach,
        helpers.notify.attach,
    })
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end
