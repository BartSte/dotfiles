local path = require("helpers.path")

---@module session
---@class M
---@field directory string The root directory for sessions
---@field save fun():nil Save the current session
---@field load fun():nil Load the session for the current directory
local M = {}

--- Make root directory for sessions
--- @return string The root directory for sessions
local function find_root_directory()
    local stdpath = vim.fn.stdpath("data")
    if type(stdpath) == "table" then
        error("Multiple data directories found")
    end
    return path.join(stdpath, "sessions")
end

--- Make session name
--- The currend working directory its top level folder name is used as the
--- session name
--- @return string The session name
local function get_session_path()
    local name = path.top_dir(vim.fn.getcwd())
    return path.join(M.directory, name) .. ".vim"
end

M.directory = find_root_directory()

M.save = function()
    vim.fn.mkdir(M.directory, "p")
    local session_path = get_session_path()
    vim.cmd("mksession! " .. session_path)
    vim.notify("Session saved: " .. session_path)
end

M.load = function()
    local session_path = get_session_path()
    if vim.fn.filereadable(session_path) == 1 then
        vim.cmd("source " .. session_path)
        vim.notify("Session loaded: " .. session_path)
    else
        vim.notify("No session found for " .. session_path)
    end
end

return M
