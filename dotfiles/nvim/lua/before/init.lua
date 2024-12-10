local M = {}

--- Prepend the lua/before directory to the rtp.
M.prepend_rtp = function()
    local path = require("helpers.path")
    vim.opt.rtp:prepend(path.join(path.config_dir(), "lua", "before"))
end

--- Require all files in the lua/before directory, except for init.lua.
M.require_all = function()
    local path = require("helpers.path")
    local this_dir = path.join(path.config_dir(), "lua", "before")
    path.require_all(this_dir)
end

return M
