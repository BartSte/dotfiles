local globals = require("gitlab.globals")
local statusline = require("gitlab.statusline")

local M = {}

local state = globals.GCS_UNKNOWN

M.get = function()
    return state
end

M.get_text = function()
    local text = statusline.state_label_for(state)
    return string.format("Duo: %s", text)
end

---@param value integer See "gitlab.globals"
M.set = function(value)
    state = value
end

return M
