local fzf = require("fzf-lua")
local join = require("helpers.path").join
local path = require("helpers.path")

local M = {}

M.files_home = function()
    fzf.files({ cwd = path.home() })
end

M.files_org = function()
    local fd_cmd = "fd --color=never --type f --hidden --follow --exclude .git"
    local grep_cmd = "grep -v org_archive$"
    fzf.files({
        cwd = join(path.home(), "dropbox", "org"),
        cmd = fd_cmd .. " | " .. grep_cmd
    })
end

M.dirs = function()
    fzf.files({
        prompt    = "Dirs❯ ",
        fd_opts   = "--type directory",
        previewer = false,
        git_icons = false,
        preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
    })
end

M.files_nvim_config = function()
    fzf.files({ cwd = join(path.home(), "dotfiles", "nvim") })
end

M.dirs_nvim_config = function()
    fzf.files({
        prompt    = "Dirs❯ ",
        cwd       = join(path.home(), "dotfiles", "nvim"),
        fd_opts   = "--type directory",
        previewer = false,
        git_icons = false,
        preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
    })
end

M.get_email = function()
    local khalrd_cmd = "khard --skip-unparsable email --parsable --remove-first-line"
    local sed_cmd = "sed 's/[ \\t].*$//'"
    local emails = vim.fn.system(khalrd_cmd .. " | " .. sed_cmd)
    fzf.fzf_exec(vim.split(emails, "\n"))
end

return M
