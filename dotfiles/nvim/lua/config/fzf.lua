local fzf = require("fzf-lua")
local map = require("helpers.keymapper")
local helpers = require("helpers.fzf")

-- By adding my custom action to this table, they show up in the fzf header.
fzf.core.ACTION_DEFINITIONS[fzf.actions.git_branch_del] = { "delete" }
fzf.core.ACTION_DEFINITIONS[fzf.actions.git_branch_add] = { "add" }
fzf.core.ACTION_DEFINITIONS[helpers.git.branch_track] = { "track" }
fzf.core.ACTION_DEFINITIONS[helpers.git.branch_rebase] = { "rebase" }
fzf.core.ACTION_DEFINITIONS[helpers.git.branch_merge] = { "merge" }

fzf.setup({
    winopts = {
        height  = 0.9,
        width   = 0.9,
        preview = {
            hidden = "hidden",
        }
    },
    keymap  = {
        builtin = {
            ["<C-p>"]    = "toggle-preview",
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"]   = "preview-page-up",
        },
        fzf = {
            ["ctrl-c"]     = "half-page-down",
            ["ctrl-u"]     = "half-page-up",
            ["ctrl-a"]     = "beginning-of-line",
            ["ctrl-e"]     = "end-of-line",
            ["ctrl-p"]     = "toggle-preview",
            ["alt-a"]      = "toggle-all",
            ["shift-down"] = "preview-page-down",
            ["shift-up"]   = "preview-page-up",
        },
    },
    git     = {
        branches = {
            actions = {
                ["ctrl-e"] = { fn = helpers.git.branch_merge, reload = true },
                ["ctrl-r"] = { fn = helpers.git.branch_rebase, reload = true },
                ["ctrl-s"] = { fn = helpers.git.branch_track, reload = true },
            },
        },
    }
})

map.nnoremap("<a-c>", helpers.dirs.cwd)
map.nnoremap("<a-C>", helpers.dirs.home)
map.nnoremap("<a-V>", helpers.dirs.nvim)

map.nnoremap("<a-o>", helpers.files.cwd)
map.nnoremap("<a-O>", helpers.files.home)
map.nnoremap("<a-s>", helpers.files.buffer_dir)
map.nnoremap("<a-v>", helpers.files.nvim)
map.nnoremap("<a-r>", helpers.files.org)

map.nnoremap("<a-B>", fzf.git_branches)
map.nnoremap("<a-T>", fzf.git_tags)

map.nnoremap("<a-d>", fzf.lsp_document_diagnostics)
map.nnoremap("<a-D>", fzf.lsp_workspace_diagnostics)

map.nnoremap('""', fzf.registers)
map.nnoremap("z=", fzf.spell_suggest)
map.nnoremap("<a-A>", fzf.live_grep_resume)
map.nnoremap("<a-M>", fzf.marks)
map.nnoremap("<a-W>", fzf.grep_cWORD)
map.nnoremap("<a-a>", fzf.live_grep)
map.nnoremap("<a-b>", fzf.buffers)
map.nnoremap("<a-h>", fzf.help_tags)
map.nnoremap("<a-t>", fzf.tabs)
map.nnoremap("<a-w>", fzf.grep_cword)
map.vnoremap("<a-a>", fzf.grep_visual)
