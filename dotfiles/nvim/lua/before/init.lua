local M = {}

--- Prepend the lua/before directory to the rtp.
M.prepend_rtp = function()
    local join = require("helpers.path").join
    local dir_config = vim.fn.stdpath('config')
    vim.opt.rtp:prepend(join(dir_config, "lua", "before"))
end

--- Require all files in the lua/before directory, except for init.lua.
M.require_all = function()
    local path = require("helpers.path")
    local dir_config = vim.fn.stdpath('config')
    local this_dir = path.join(dir_config, "lua", "before")
    local modules = path.glob_modules(this_dir)
    for _, module in ipairs(modules) do
        require(module)
    end
end

return M
