local M = {}

--- The formatter of ruff is not allowed.
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.format = function(client)
    local is_ruff = client.name == "ruff"
    return not is_ruff
end

---@param action lsp.CodeAction The code action to be executed
---@return
M.code_action = function(action)
    return false --- isort is used instead of code_action
end

return M
