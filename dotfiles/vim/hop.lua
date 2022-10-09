local hop = require('hop')
local hint = require('hop.hint')
local jump_target = require('hop.jump_target')

local function hop_t()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_offset = -1
    }
    hop.hint_char1(opts)
end

local function hop_T()
    local opts = {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_offset = -1
    }
    hop.hint_char1(opts)
end

local function hop_f()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_char1(opts)
end

local function  hop_F()
    local opts = {direction = hint.HintDirection.BEFORE_CURSOR}
    hop.hint_char1(opts)
end

local function  hop_d()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_lines(opts)
end

local function  hop_u()
    local opts = {direction = hint.HintDirection.BEFORE_CURSOR}
    hop.hint_lines(opts)
end

local function  hop_w()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_words(opts)
end

local function  hop_W()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_with(hints, hop.opts)
end

local function  hop_b()
    local opts = {direction = hint.HintDirection.BEFORE_CURSOR}
    hop.hint_words(opts)
end

local function  hop_B()
    local regex = "[^ \t]\\+"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    hop.opts.direction = hint.HintDirection.BEFORE_CURSOR
    hop.hint_with(hints, hop.opts)
end

local function  hop_e()
    local opts = {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END
    }
    hop.hint_words(opts)
end

local function  hop_E()
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
     keys = 'rlaodhgmfiwypuq;cx/jbvtnse',
     jump_on_sole_occurrence = true,
     uppercase_labels = true,
     multi_windows = false
})

vim.keymap.set('', '<leader>t', hop_t)
vim.keymap.set('', '<leader>T', hop_T)
vim.keymap.set('', '<leader>f', hop_f)
vim.keymap.set('', '<leader>F', hop_F)
vim.keymap.set('', '<leader>d', hop_d)
vim.keymap.set('', '<leader>u', hop_u)
vim.keymap.set('', '<leader>w', hop_w)
vim.keymap.set('', '<leader>W', hop_W)
vim.keymap.set('', '<leader>b', hop_b)
vim.keymap.set('', '<leader>B', hop_B)
vim.keymap.set('', '<leader>e', hop_e)
vim.keymap.set('', '<leader>E', hop_E)
vim.keymap.set('', '<leader>ge', hop_ge)
vim.keymap.set('', '<leader>gE', hop_gE)
