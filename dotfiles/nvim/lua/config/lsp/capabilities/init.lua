---@class Capabilities
---Functions that configure the server capabilities.
---@field update function(client: lsp.Client, bufnr: number) Update the server
---capabilities for the given client and buffer. If the client is not specified,
---in this module, no changes are made.
---@field decorate function(fn: function(vim.lsp.Client, number)):
---function(vim.lsp.Client, number) Decorate a function that takes a client and
---buffer number with the update function.
local M = {}

local project_specific = require("projectrc").require(
    "config.lsp.capabilities",
    { fallback_value = {} }
)
M = vim.tbl_deep_extend("force", M, project_specific)

---Update the server capabilities for the given client and buffer. If the client
---is not specified in this module, no changes are made.
---@param client vim.lsp.Client The client to update
---@param bufnr number The buffer number to update
function M.update(client, bufnr)
    if M[client.name] then
        M[client.name](client, bufnr)
    end
end

---Decorate a function that takes a client and buffer number with the update
---function.
---@param fn function(lsp.Client, number)|nil The function to decorate
---@return function(lsp.Client, number) The decorated function
function M.decorate(fn)
    return function(client, bufnr)
        M.update(client, bufnr)
        if fn then
            return fn(client, bufnr)
        end
    end
end

return M
