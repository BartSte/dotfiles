local helpers = require("helpers.lsp")
local mappings = require('config.lsp.mappings')
local server_opts = require('config.lsp.servers')
local capabilities = require('config.lsp.capabilities')

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
for name, config in pairs(server_opts) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

---Instead of using the client's on_attach hook, the LspAttach autocommand is
---used because the latter is triggered for each new buffer, which is not the
---case for the former.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client or client == nil then
            return
        end
        capabilities.update(client, ev.buf)
        mappings.on_lsp_attach(client, ev.buf)
        helpers.notify.attach(client, ev.buf)
    end,
})
