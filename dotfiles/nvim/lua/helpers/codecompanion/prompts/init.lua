local path = require("helpers.path")
local this_dir = path.join_config_dir("lua", "helpers", "codecompanion", "prompts")

---@class CodeCompanionPrompts
---@field docstring table
---@field typehint table
return path.require_all(this_dir)
