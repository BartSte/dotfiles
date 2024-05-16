local M = {}

--- Allow all formatters.
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    return true
end

return M

