local M = {}

--- Set up the language server
---@param client vim.lsp.Client
function M.ruff(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

return M