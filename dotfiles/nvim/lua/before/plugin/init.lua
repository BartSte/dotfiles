local M = {}

--- Require all files in the lua/before/plugin directory, except for init.lua.
M.load = function()
    local path = require("helpers.path")
    local dir_config = vim.fn.stdpath('config')
    local this_dir = path.join(dir_config, "lua", "before", "plugin")
    local files = path.glob(this_dir, "/init$")
    for _, file in ipairs(files) do
        local module = file:gsub(path.path_separator, ".")
        require(module)
    end
end


return M
