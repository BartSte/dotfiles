local M = {}

M.is_linux = function()
    return vim.fn.has("linux") == 1
end

--- If the environment variable WH exists, return true.
---@return
M.is_wsl = function()
    return os.getenv('WH') ~= nil
end

return M
