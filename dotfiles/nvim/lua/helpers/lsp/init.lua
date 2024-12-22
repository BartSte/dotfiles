local path = require("helpers.path")

---@class HelpersLsp
---@field underline Underline
---@field virtualtext VirtualText
---@field notify Notify
---@field organize_imports function
local M = path.require_all(path.join(path.config_dir(), "lua", "helpers", "lsp"))

return M
