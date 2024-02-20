local hop = require('hop')
local hint = require('hop.hint')
local jump_target = require('hop.jump_target')
local jump_regex = require('hop.jump_regex')

local M = {}

M.hop_char1 = function()
    local opts = { direction = { nil } }
    hop.hint_char1(opts)
end

M.hop_w = function()
    local opts = { direction = hint.HintDirection.AFTER_CURSOR }
    hop.hint_words(opts)
end

M.hop_W = function()
    local regex = "[^ \t]\\+"
    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    local hints = jump_regex.regex_by_case_searching(regex, false, hop.opts)
    hop.hint_with_regex(hints, hop.opts)
end

M.hop_b = function()
    local opts = { direction = hint.HintDirection.BEFORE_CURSOR }
    hop.hint_words(opts)
end

M.hop_B = function()
    local regex = "[^ \t]\\+"
    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    local hints = jump_regex.regex_by_case_searching(regex, false, hop.opts)
    hop.hint_with_regex(hints, hop.opts)
end

M.hop_e = function()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

M.hop_E = function()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_position = hint.HintPosition.END
    local hints = jump_regex.regex_by_case_searching(regex, false, hop.opts)
    hop.hint_with_regex(hints, hop.opts)
end

M.hop_ge = function()
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

M.hop_gE = function()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    hop.hint_position = hint.HintPosition.END
    local hints = jump_regex.regex_by_case_searching(regex, false, hop.opts)
    hop.hint_with_regex(hints, hop.opts)
end

return M
