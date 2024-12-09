local M = {}

-- Use ruff for formatting with python instead of null-ls
---@param client table lsp client
---@return boolean result true: allow, false: not allow
M.format = function(client)
    local is_python = client.config.filetypes[1] == "python"
    local is_null_ls = client.name == "null-ls"
    local result = not (is_python and is_null_ls)
    return result
end

---Return true if the code action should be allowed
---@return boolean result true: allow, false: not allow
M.code_action = function()
    return vim.bo.filetype == "python"
end


return M
