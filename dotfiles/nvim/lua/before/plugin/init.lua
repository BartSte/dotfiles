local M = {}

--- Require all files in the lua/before/plugin directory, except for init.lua.
M.load = function()
    local path = require("helpers.path")
    local dir_config = vim.fn.stdpath('config')
    local this_dir = path.join(dir_config, "lua", "before", "plugin")
    local modules = path.glob_modules(this_dir)
    for _, module in ipairs(modules) do
        require(module)
    end
end


return M
