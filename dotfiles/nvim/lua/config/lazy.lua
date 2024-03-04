local path = require("helpers.path")

local M = {}

local dir_config = vim.fn.stdpath('config')
local lua_after = path.join(dir_config, "lua", "after")

local change_detection = { enabled = false, }
local rtp = {
    reset = true,
    paths = { lua_after },
    disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
    }
}

local opts = {
    change_detection = change_detection,
    performance = { rtp = rtp },
}

M.setup = function()
    require('lazy').setup("plugins", opts)
end

return M
