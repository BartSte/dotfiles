local M = {}

--- The formatter of ruff_lsp is not allowed.
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    return client.name ~= "ruff_lsp"
end

return M
