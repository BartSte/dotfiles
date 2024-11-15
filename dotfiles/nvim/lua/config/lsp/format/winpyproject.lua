local M = {}

--- The formatter of ruff_lsp is not allowed.
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    -- if file type is python, then do not allow ruff_lsp
    if client.config.filetypes[1] == "python" then
        return client.name ~= "ruff"
    end
end

return M
