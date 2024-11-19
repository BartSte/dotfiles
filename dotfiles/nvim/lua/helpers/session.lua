local path = require("helpers.path")

local M = {}

--- Make a session name
--- The name is the name of the current directory.
--- @return string The name of the session
local function make_session_name()
    local cwd = vim.fn.getcwd()
    local name = path.dirname(cwd)
    return name
end

M.directory = path.join(vim.fn.stdpath("data"), "sessions")

M.save = function()
    vim.fn.mkdir(M.directory, "p")
    local name = make_session_name()
    local path_session = path.join(M.directory, name) .. ".vim"
    vim.cmd("mksession! " .. path_session)
    vim.notify("Session saved: " .. path_session)
end

M.load = function()
    local name = make_session_name()
    local path_session = path.join(M.directory, name) .. ".vim"
    if vim.fn.filereadable(path_session) == 1 then
        vim.cmd("source " .. path_session)
        vim.notify("Session loaded: " .. path_session)
    else
        vim.notify("No session found for " .. name)
    end
end

return M
