local M = {}

-- Use ruff for formatting with python instead of null-ls
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    local is_python = client.config.filetypes[1] == "python"
    local is_null_ls = client.name == "null-ls"
    return not (is_python and is_null_ls)
end

return M
