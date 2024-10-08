local M = {}

-- Use ruff for formatting with python instead of null-ls
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.filter = function(client)
    local is_python = client.config.filetypes[1] == "python"
    local is_null_ls = client.name == "null-ls"
    local result = not (is_python and is_null_ls)
    -- print("Filter result: ", result, "client name: ", client.name, "filetype: ", client.config.filetypes[1])
    return result
end

return M
