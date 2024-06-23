local fzf = require("fzf-lua")
local map = require("helpers.keymapper")
local helpers = require("helpers.fzf")

local opts = {
    winopts = {
        height  = 0.9,
        width   = 0.9,
        preview = {
            hidden = "hidden",
        }
    },
    keymap  = {
        builtin = {
            ["<F2>"]     = "toggle-fullscreen",
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
}

fzf.setup(opts)

map.nnoremap("<a-A>", fzf.live_grep)
map.nnoremap("<a-H>", fzf.help_tags)
map.nnoremap("<a-O>", helpers.files_all)
map.nnoremap("<a-V>", helpers.dirs_nvim_config)
map.nnoremap("<a-a>", fzf.grep)
map.nnoremap("<a-b>", fzf.buffers)
map.nnoremap("<a-c>", helpers.dirs)
map.nnoremap("<a-h>", helpers.files_home)
map.nnoremap("<a-o>", fzf.files)
map.nnoremap("<a-r>", helpers.files_org)
map.nnoremap("<a-t>", fzf.tabs)
map.nnoremap("<a-v>", helpers.files_nvim_config)
