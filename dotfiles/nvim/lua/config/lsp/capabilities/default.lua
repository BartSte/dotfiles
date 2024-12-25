local M = {}

function M.ruff(client, _)
    client.server_capabilities.format_actions = { "source.organizeImports.ruff" }
end

return M
