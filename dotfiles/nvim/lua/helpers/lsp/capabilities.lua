---@class CapabilityHelper
---@field has_capability fun(client: vim.lsp.Client, capability: string): boolean
local M = {}

--- Return true if the client has the specified capability.
---@param client vim.lsp.Client The client to check for the capability
---@param capability string The capability to check for
---@return boolean
function M.has_capability(client, capability)
    return client.server_capabilities[capability] == true
end

return M
