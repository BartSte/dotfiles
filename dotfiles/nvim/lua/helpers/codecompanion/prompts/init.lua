local path = require("helpers.path")
local this_dir = path.join_config_dir("lua", "helpers", "codecompanion", "prompts")

---@class helpers.CodeCompanion.Prompts
---@field changes table
---@field check table
---@field docstring table
---@field explain table
---@field fix table
---@field lsp_explain table
---@field refactor table
---@field typehint table
---@field unittest table
return path.require_all(this_dir)
