local M = {}
M.state = {}
M.icon = ""

local state = -1 -- same as globals.GCS_UNKNOWN

function M.state.get()
    return state
end

function M.state.get_icon()
    if vim.api.nvim_get_mode().mode ~= "i" then
        return M.icon
    end

    local ok, globals = pcall(require, "gitlab.globals")
    if not ok then
        return ""
    end

    if state == globals.GCS_AVAILABLE_AND_ENABLED then
        return M.icon
    elseif state == globals.GCS_WAITING then
        return M.icon .. " "
    elseif state == globals.GCS_SUCCESS then
        return M.icon .. " "
    elseif state == globals.GCS_FAILED then
        return M.icon .. " "
    elseif state == globals.GCS_NONE then
        return M.icon .. " "
    else
        return ""
    end
end

function M.state.set(value)
    state = value
end

return M
