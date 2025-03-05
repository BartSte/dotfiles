---@class helpers.CodeCompanion.Notify
---@field default_models function
local M = {}

--- Displays the configured adapter models for different strategy types
function M.default_models()
  local strategies = require("codecompanion.config").config.strategies
  local message = string.format(
    "chat\t= %s\ninline\t= %s\ncmd\t= %s",
    strategies.chat.adapter, strategies.inline.adapter, strategies.cmd.adapter)
  Snacks.notify.info(message, { title = "Default Models" })
end

return M
