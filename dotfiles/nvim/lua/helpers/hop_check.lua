local hop = require('hop')
local api = vim.api

local M = {}

------------------------------------------------------------------------------
-- Copied from https://github.com/smoka7/hop.nvim/blob/master/lua/hop/init.lua
-- As ths is a private function, though it seems an important check to be done.
------------------------------------------------------------------------------
-- Ensure options are sound.
--
-- Some options cannot be used together. For instance, multi_windows and current_line_only don’t really make sense used
-- together. This function will notify the user of such ill-formed configurations.
---@param opts Options
M.check_opts = function(opts)
    if not opts then
        return
    end

    if vim.version.cmp({ 0, 10, 0 }, vim.version()) < 0 then
        local hint = require('hop.hint')
        opts.hint_type = hint.HintType.OVERLAY
    end

    if opts.multi_windows and opts.current_line_only then
        vim.notify('Cannot use current_line_only across multiple windows', vim.log.levels.WARN)
    end

    -- disable multi windows for visual mode
    local mode = api.nvim_get_mode().mode
    if mode ~= 'n' and mode ~= 'nt' then
        opts.multi_windows = false
    end
end

-- Copied from https://github.com/smoka7/hop.nvim/blob/master/lua/hop/init.lua
-- As ths is a private function, though it seems an important check to be done.
--
-- Allows to override global options with user local overrides.
---@param opts Options
---@return Options
M.override_opts = function(opts)
    M.check_opts(opts)
    return setmetatable(opts or {}, { __index = hop.opts })
end

return M
