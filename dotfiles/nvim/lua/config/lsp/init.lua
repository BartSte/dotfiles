local capabilities = require('config.lsp.capabilities')
local fn           = require("helpers.fn")
local helpers      = require("helpers.lsp")
local lspconfig    = require("lspconfig")
local mappings     = require('config.lsp.mappings')
local server_opts  = require('config.lsp.servers')
local util         = require("lspconfig.util")

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = { border = 'rounded' },
})

--- Wraps and decorates the root_dir function or path.
---@param root_dir string|function Original root directory string or function.
---@return function A function that resolves the root directory for a given buffer.
local function decorate_root_dir(root_dir)
    return function(bufnr, callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname:sub(1, 11) == "fugitive://" then
        return nil
    end
    if type(root_dir) == "function" then
        root_dir(bufnr, callback)
    end
    callback(root_dir)
    end
end


---The on_attach function can be used to setup configurations that are specific
---to a server. Server capabilities can be specified in the capabilities module.
for name, config in pairs(server_opts) do
    config.root_dir = decorate_root_dir(config.root_dir)
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

---Instead of using the client's on_attach hook, the LspAttach autocommand is
---used because the latter is triggered for each new buffer, which is not the
---case for the former.
vim.api.nvim_create_autocmd('LspAttach', {
    --- Handler for the LspAttach event. Updates client capabilities and mappings.
    ---@param ev table Event data from Neovim, containing `client_id` and `buf`.
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
