local M = {}

function M.ruff(client, _)
    client.server_capabilities.format_actions = { "source.organizeImports.ruff" }
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
end

return M
