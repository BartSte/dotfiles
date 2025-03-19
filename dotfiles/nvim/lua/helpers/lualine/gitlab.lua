local globals = require("gitlab.globals")

local M = {}
M.state = {}
M.icon = ""

local state = globals.GCS_UNKNOWN
local state_array = { globals.GCS_UNKNOWN }

function M.state.get()
    return state
end

function M.state.get_icon()
    if state == globals.GCS_AVAILABLE_AND_ENABLED then
        return M.icon
    elseif state == globals.GCS_CHECKING then
        return M.icon .. "  "
    elseif state == globals.GCS_UPDATED then
        return M.icon .. "  "
    elseif state == globals.GCS_AVAILABLE_AND_DISABLED then
        return M.icon .. "  "
    elseif state == globals.GCS_INSTALLED then
        return ""
    elseif state == globals.GCS_UNAVAILABLE then
        return ""
    elseif state == globals.GCS_UNKNOWN then
        return ""
    end
end

function M.state.set(value)
    state = value
end

return M
