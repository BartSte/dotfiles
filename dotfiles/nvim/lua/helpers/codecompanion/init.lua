local rc = require("projectrc")
local path = require("helpers.path")
local this_dir = path.join_config_dir("lua", "helpers", "codecompanion")

---@class helpers.CodeCompanion
---@field adapters helpers.CodeCompanion.Adapters
---@field notify helpers.CodeCompanion.Notify
---@field require_by_hostname function Requires a module based on the current
---hostname, with fallback to module called `default`.
---@field workspace helpers.CodeCompanion.Workspace
local M = path.require_all(this_dir)

---Requires a module based on the current hostname, with fallback to default configuration
---@param module string The base module path to require from
---@return any result The required module or fallback implementation
function M.require_by_hostname(module)
    local name = vim.fn.hostname()
    local fallback = function() return rc.try_require(module, "default") end
    return rc.try_require(module, name, fallback)
end

return M
