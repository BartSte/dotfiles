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
})


map.nnoremap("<a-c>", helpers.dirs)
map.nnoremap("<a-C>", helpers.dirs_home)
map.nnoremap("<a-o>", fzf.files)
map.nnoremap("<a-O>", helpers.files_home)

map.nnoremap("<a-b>", fzf.buffers)
map.nnoremap("<a-p>", fzf.help_tags)
map.nnoremap("<a-r>", helpers.files_org)
map.nnoremap("<a-t>", fzf.tabs)
map.nnoremap("<a-v>", helpers.files_nvim_config)

map.nnoremap("<a-A>", fzf.live_grep_resume)
map.nnoremap("<a-W>", fzf.grep_cWORD)
map.nnoremap("<a-a>", fzf.live_grep)
map.nnoremap("<a-w>", fzf.grep_cword)
map.vnoremap("<a-a>", fzf.grep_visual)
