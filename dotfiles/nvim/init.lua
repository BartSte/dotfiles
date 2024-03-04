-- Checkout the README.md for information how the configuration is organized.

local path = require("helpers.path")
local dir_config = vim.fn.stdpath('config')
local before = path.join(dir_config, "lua", "before")
-- vim.opt.rtp:prepend(before)

require("settings").setup()
require("helpers.lazy").bootstrap()
require("config.lazy").setup()
vim.opt.rtp:prepend(before)
