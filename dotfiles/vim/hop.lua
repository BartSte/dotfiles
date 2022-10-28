local hop = require('hop')
local hint = require('hop.hint')
local jump_target = require('hop.jump_target')

local function hop_char1()
    local opts = {}
    hop.hint_char1(opts)
end

local function  hop_w()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_words(opts)
end

local function hop_W()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_with(hints, hop.opts)
end

local function hop_b()
    local opts = {direction = hint.HintDirection.BEFORE_CURSOR}
    hop.hint_words(opts)
end

local function hop_B()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    hop.hint_with(hints, hop.opts)
end

local function hop_e()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

local function hop_E()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_position = hint.HintPosition.END
    hop.hint_with(hints, hop.opts)
end

local function  hop_ge()
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

local function  hop_gE()
    local regex = "[^ \t]\\($\\|[ \t]\\)"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    hop.hint_position = hint.HintPosition.END
    hop.hint_with(hints, hop.opts)
end

hop.setup({
     keys = 'rlaodhgmfiwypuq;cx/jbvsetn',
     jump_on_sole_occurrence = true,
     uppercase_labels = true,
     multi_windows = false
})

vim.keymap.set('n', 'S', hop_char1)

vim.keymap.set('n', 'j', hop_b, { noremap = true })
vim.keymap.set('n', 'J', hop_B, { noremap = true })
vim.keymap.set('n', 'l', hop_ge, { noremap = true })
vim.keymap.set('n', 'L', hop_gE, { noremap = true })

vim.keymap.set('n', 'k', hop_w, { noremap = true })
vim.keymap.set('n', 'K', hop_W, { noremap = true })
vim.keymap.set('n', 'h', hop_e, { noremap = true })
vim.keymap.set('n', 'H', hop_E, { noremap = true })
