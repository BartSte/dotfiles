local M = {}

--- The formatter of ruff is not allowed.
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    local is_ruff = client.name == "ruff"
    -- dd("is_ruff", is_ruff)
    return not is_ruff
end

return M
