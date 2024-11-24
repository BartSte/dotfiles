-- Checkout the README.md for information how the configuration is organized.

-- The `lua/after` directory is appended to the rtp option in `config.lazy`. The
-- `lua/before` needs to be prepended to the rtp but this is not straight
-- forward, as the rtp is reset by lazy for performance reasons. Therefore, the
-- `lua/before` directory is required through a function.

-- See https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
vim.print = _G.dd

require("before").require_all()
require("helpers.lazy").bootstrap()
require("config.lazy").setup()
