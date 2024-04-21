local fzf = require("fzf-lua")
local map = require("helpers.keymapper")
local join = require("helpers.path").join

local M = {}

local function files_home()
    fzf.files({ cwd = os.getenv("HOME")})
end

local function dirs()
    fzf.files({ cmd = "fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t d" })
end

local function files_nvim_config()
    fzf.files({ cwd = join(os.getenv("HOME"), "dotfiles", "nvim") })
end

require("fzf-lua")

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
            ["alt-a"]      = "toggle-all",
            ["shift-down"] = "preview-page-down",
            ["shift-up"]   = "preview-page-up",
        },
    },
}

M.setup = function()
    fzf.setup(opts)
    map.nnoremap("<a-o>", fzf.files)
    map.nnoremap("<a-b>", fzf.buffers)
    map.nnoremap("<a-h>", files_home)
    map.nnoremap("<a-v>", files_nvim_config)
    map.nnoremap("<a-H>", fzf.help_tags)
    map.nnoremap("<a-a>", fzf.grep)
    map.nnoremap("<a-A>", fzf.live_grep)
    map.nnoremap("<a-B>", fzf.git_branches)
    map.nnoremap("<a-c>", dirs)
end

return M
