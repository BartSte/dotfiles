---@class Debug
---@field setup function
local M = {}

--- See https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
M.setup = function()
    _G.dd = function(...) require("snacks.debug").inspect(...) end
    _G.bt = function() require("snacks.debug").backtrace() end
    _G.p = function(...) require("snacks.debug").profile(...) end
    vim.print = _G.dd
end

return M
