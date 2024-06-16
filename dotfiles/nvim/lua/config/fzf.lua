local fzf = require("fzf-lua")
local path = require("helpers.path")
local map = require("helpers.keymapper")
local join = require("helpers.path").join

-- TODO: mode all function to helpers such that other modules can use them 
-- so I can set fzf maps for specific filetypes
local function files_home()
    fzf.files({ cwd = path.home() })
end

local function files_org()
    local fd_cmd = "fd --color=never --type f --hidden --follow --exclude .git"
    local grep_cmd = "grep -v org_archive$"
    fzf.files({
        cwd = join(path.home(), "dropbox", "org"),
        cmd = fd_cmd .. " | " .. grep_cmd
    })
end

local function dirs()
    fzf.files({
        prompt    = "Dirs❯ ",
        fd_opts   = "--type directory",
        previewer = false,
        git_icons = false,
        preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
    })
end

local function files_nvim_config()
    fzf.files({ cwd = join(path.home(), "dotfiles", "nvim") })
end

local function get_email()
    local emails = vim.fn.system("khard --skip-unparsable email --parsable --remove-first-line | sed 's/[ \\t].*$//'")
    fzf.fzf_exec(vim.split(emails, "\n"))
end

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
map.nnoremap("<a-o>", fzf.files)
map.nnoremap("<a-b>", fzf.buffers)
map.nnoremap("<a-h>", files_home)
map.nnoremap("<a-v>", files_nvim_config)
map.nnoremap("<a-H>", fzf.help_tags)
map.nnoremap("<a-a>", fzf.grep)
map.nnoremap("<a-A>", fzf.live_grep)
map.nnoremap("<a-c>", dirs)
map.nnoremap("<a-r>", files_org)
map.nnoremap("<a-t>", fzf.tabs)
