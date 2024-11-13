local M = {}

M.is_linux = function()
    return vim.fn.has("linux") == 1
end

--- If the environment variable WH exists, return true.
---@return
M.is_wsl = function()
    return os.getenv('WH') ~= nil
end

-- Open a file in the default system application.
M.open = function(path)
    if M.is_linux() then
        return vim.system({ "open", vim.fn.expand(path) })
    else
        return vim.ui.open(path)
    end
end

return M
