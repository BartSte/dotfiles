local M = {}

--- Return the credentials for the given entry name.
---@param name string The name of the entry
---@return string token
function M.get(name)
  local cmd = "rbw unlocked 2>/dev/null && rbw get " .. name .. " 2>/dev/null"
  local handle = io.popen(cmd)
  if not handle then
    return ""
  end
  local token = handle:read("*a")
  handle:close()
  return token and token:gsub("%s+$", "")
end

--- Set the `env` variable to the token stored in the entry `name`.
---@param name string The name of the entry
---@param env string The environment variable to set to the token
---@return boolean True if env variable was successfully set, false otherwise.
function M.set_env(name, env)
  local token = M.get(name)
  if token and #token > 0 then
    vim.env[env] = token
    return true
  end
  return false
end

return M
