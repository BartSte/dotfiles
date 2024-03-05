local M = {}


--- Prepend the lua/before directory to the rtp.
M.prepend_rtp = function()
    local join = require("helpers.path").join
    local dir_config = vim.fn.stdpath('config')
    vim.opt.rtp:prepend(join(dir_config, "lua", "before"))
end

return M
