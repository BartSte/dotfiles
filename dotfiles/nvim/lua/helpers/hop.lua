local api = vim.api
local hop = require('hop')
local hint = require('hop.hint')
local jump_regex = require('hop.jump_regex')

local M = {}

--------------------------------------------------------------------------------
-- Copied from https://github.com/smoka7/hop.nvim/blob/master/lua/hop/init.lua
-- As ths is a private function, though it seems an important check to be done.
--------------------------------------------------------------------------------
-- Ensure options are sound.
--
-- Some options cannot be used together. For instance, multi_windows and
-- current_line_only don’t really make sense used together. This function will
-- notify the user of such ill-formed configurations.
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

--------------------------------------------------------------------------------
-- Copied from https://github.com/smoka7/hop.nvim/blob/master/lua/hop/init.lua
-- As ths is a private function, though it seems an important check to be done.
--------------------------------------------------------------------------------
-- Allows to override global options with user local overrides.
---@param opts Options
---@return Options
M.override_opts = function(opts)
    M.check_opts(opts)
    return setmetatable(opts or {}, { __index = hop.opts })
end

--------------------------------------------------------------------------------
-- Own code below
--------------------------------------------------------------------------------

M.hop_char1 = function()
    local opts = { direction = { nil } }
    hop.hint_char1(opts)
end

M.hop_w = function()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR
    }
    hop.hint_words(opts)
end

M.hop_wo = function()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_offset = -1
    }
    hop.hint_words(opts)
end

M.hop_b = function()
    local opts = { direction = hint.HintDirection.BEFORE_CURSOR }
    hop.hint_words(opts)
end

M.hop_e = function()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

M.hop_ge = function()
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

local function hint_regex(pattern, opts)
    opts = M.override_opts(opts)
    local regex = jump_regex.regex_by_case_searching(pattern, false, opts)
    hop.hint_with_regex(regex, opts)
end

M.hop_W = function()
    local pattern = "[^ \t]\\+"
    local opts = { direction = hint.HintDirection.AFTER_CURSOR }
    hint_regex(pattern, opts)
end

M.hop_Wo = function()
    local pattern = "[^ \t]\\+"
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_offset = -1
    }
    hint_regex(pattern, opts)
end

M.hop_B = function()
    local pattern = "[^ \t]\\+"
    local opts = { direction = hint.HintDirection.BEFORE_CURSOR }
    hint_regex(pattern, opts)
end

M.hop_E = function()
    local pattern = "[^ \t]\\($\\|\\([ \t]\\)\\)\\@="
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END,
    }
    hint_regex(pattern, opts)
end

M.hop_gE = function()
    local pattern = "[^ \t]\\($\\|\\([ \t]\\)\\)\\@="
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END,
    }
    hint_regex(pattern, opts)
end

--- Detects the begin and end of each WORD which is equivalent to combinings vim's W and E command.
M.hop_WORDS = function()
    local pattern =  [[\v\S+]]
    local opts = {}
    hint_regex(pattern, opts)
end


return M
