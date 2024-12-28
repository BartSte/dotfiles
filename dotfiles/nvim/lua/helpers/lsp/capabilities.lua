---@class CapabilityHelper
---@field has_capability fun(client: vim.lsp.Client, capability: string): boolean
local M = {}

--- Return true if the client has the specified capability.
--- Null-ls sources are also supported.
---@param client vim.lsp.Client|NullLsSource The client to check for the
---capability
---@param capability string The capability to check for
---@return boolean
function M.has_capability(client, capability)
    if client.server_capabilities and client.server_capabilities[capability] then
        local value = client.server_capabilities[capability]
        return value == true or next(value) ~= nil
    elseif client.methods then
        return client.methods[capability] == true
    else
        return false
    end
end

return M
