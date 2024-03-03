local M = {}

local sep = package.config:sub(1, 1)
local dir_config = vim.fn.stdpath('config')
local lua_after = dir_config .. sep .. 'lua' .. sep .. 'after'

local change_detection = { enabled = false, }
local rtp = { paths = { lua_after } }
local disabled_plugins = {
    "gzip",
    "netrwPlugin",
    "tarPlugin",
    "tutor",
    "zipPlugin",
}

local opts = {
    change_detection = change_detection,
    performance = { rtp = rtp },
    disabled_plugins = disabled_plugins,
}

M.setup = function()
    require('lazy').setup('plugins', opts)
end

return M
