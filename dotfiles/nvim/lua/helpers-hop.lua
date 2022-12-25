local hop = require('hop')
local hint = require('hop.hint')
local jump_target = require('hop.jump_target')

M = {}

local function bugfix()
    vim.cmd('.g/^$/normal )')
end

M.hop_char1 = function()
    local opts = {}
    bugfix()
    hop.hint_char1(opts)
end

M.hop_w = function()
    local opts = { direction = hint.HintDirection.AFTER_CURSOR }
    bugfix()
    hop.hint_words(opts)
end

M.hop_W = function()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    bugfix()
    hop.hint_with(hints, hop.opts)
end

M.hop_b = function()
    local opts = { direction = hint.HintDirection.BEFORE_CURSOR }
    bugfix()
    hop.hint_words(opts)
end

M.hop_B = function()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    bugfix()
    hop.hint_with(hints, hop.opts)
end

M.hop_e = function()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END
    }
    bugfix()
    hop.hint_words(opts)
end

M.hop_E = function()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_position = hint.HintPosition.END
    bugfix()
    hop.hint_with(hints, hop.opts)
end

M.hop_ge = function()
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END
    }
    bugfix()
    hop.hint_words(opts)
end

M.hop_gE = function()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    hop.hint_position = hint.HintPosition.END
    bugfix()
    hop.hint_with(hints, hop.opts)
end

return M
