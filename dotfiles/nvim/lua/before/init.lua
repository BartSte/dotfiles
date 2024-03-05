
local M = {}


--- Adds the lua/before directory to the rtp.
M.set_rtp = function()
    local path = require("helpers.path")
    local dir_config = vim.fn.stdpath('config')
    local before = path.join(dir_config, "lua", "before")
    vim.opt.rtp:prepend(before)
end

return M
