local fzf = require("fzf-lua")
local map = require("helpers.keymapper")
local join = require("helpers.path").join

local M = {}

local function files_home()
    fzf.files({ cwd = os.getenv("HOME") })
end

local function files_nvim_config()
    fzf.files({ cwd = join(os.getenv("HOME"), "dotfiles", "nvim") })
end


local opts = {}

M.setup = function()
    fzf.setup(opts)
    map.nnoremap("<a-o>", fzf.files)
    map.nnoremap("<a-b>", fzf.buffers)
    map.nnoremap("<a-h>", files_home)
    map.nnoremap("<a-v>", files_nvim_config)
    map.nnoremap("<a-H>", fzf.help_tags)
end

return M
