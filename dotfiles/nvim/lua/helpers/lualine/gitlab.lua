local M = {}
M.state = {}
M.icon = ""

local state = -1 -- same as globals.GCS_UNKNOWN

function M.state.get()
    return state
end

function M.state.get_icon()
    local ok, globals = pcall(require, "gitlab.globals")
    if not ok then
        return ""
    end

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
