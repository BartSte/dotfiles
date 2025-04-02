local M = {}

function M.null_ls(client, _)
    -- TODO: disabe the lsp progress here?
end

--- Set up the language server
---@param client vim.lsp.Client
function M.ruff(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

return M
