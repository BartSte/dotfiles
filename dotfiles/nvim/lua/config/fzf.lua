local fzf = require("fzf-lua")
local map = require("helpers.keymapper")
local helpers = require("helpers.fzf")

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
            ["ctrl-d"]     = "half-page-down",
            ["ctrl-u"]     = "half-page-up",
            ["ctrl-a"]     = "beginning-of-line",
            ["ctrl-e"]     = "end-of-line",
            ["ctrl-p"]     = "toggle-preview",
            ["alt-a"]      = "toggle-all",
            ["shift-down"] = "preview-page-down",
            ["shift-up"]   = "preview-page-up",
        },
    },
})

map.nnoremap("<a-f>", fzf.files)
map.nnoremap("<a-b>", fzf.buffers)
map.nnoremap("<a-d>", helpers.dirs)
map.nnoremap("<a-e>", fzf.help_tags)
map.nnoremap("<a-h>", helpers.files_home)
map.nnoremap("<a-r>", helpers.files_org)
map.nnoremap("<a-t>", fzf.tabs)
map.nnoremap("<a-v>", helpers.files_nvim_config)

--The capital version of the keymap is used to search without .ignore.
map.nnoremap("<a-F>", helpers.files_all)
map.nnoremap("<a-D>", helpers.dirs_all)
map.nnoremap("<a-H>", helpers.files_home_all)

-- With grep seach, the capital rule does not apply.
map.nnoremap("<a-A>", fzf.live_grep_resume)
map.nnoremap("<a-W>", fzf.grep_cWORD)
map.nnoremap("<a-a>", fzf.live_grep)
map.nnoremap("<a-w>", fzf.grep_cword)
map.vnoremap("<a-a>", fzf.grep_visual)
