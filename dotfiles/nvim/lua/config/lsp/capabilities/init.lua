---@class Capabilities
---Functions that configure the server capabilities.
---@field update function(client: lsp.Client, bufnr: number) Update the server
---capabilities for the given client and buffer. If the client is not specified,
---in this module, no changes are made.
local M = {}

local project_specific = require("projectrc").require("config.lsp.capabilities")
M = vim.tbl_deep_extend("force", M, project_specific)

---Update the server capabilities for the given client and buffer. If the client
---is not specified in this module, no changes are made.
---@param client vim.lsp.Client The client to update
---@param bufnr number The buffer number to update
function M.update(client, bufnr)
    -- replace - with _
    local name = string.gsub(client.name, "-", "_")
    if M[name] then
        M[name](client, bufnr)
    end
end

return M
