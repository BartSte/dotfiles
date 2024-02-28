local M = {}

--- Get the value of the environment variable `SESSION_NAME`. If it is set, 
--- return the following string: `{SESSION_NAME}-{file_name}`. Otherwise, return
--- `file_name`.
---@param file_name 
M.update_file_name = function(file_name)
    local session_name = os.getenv("SESSION_NAME")
    if session_name then
        return session_name .. "-" .. file_name
    end
    return file_name
end

return M
