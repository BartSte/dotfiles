local fzf = require("fzf-lua")
local join = require("helpers.path").join
local path = require("helpers.path")

local M = {
    files = {
        opts = {}
    },
    dirs = {
        opts = {
            prompt    = "Dirs❯ ",
            fd_opts   = "--type directory",
            previewer = false,
            git_icons = false,
            preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
        }
    },
    git = {}
}

local function file_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.files.opts, opts)
    fzf.files(opts)
end

local function dir_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.dirs.opts, opts)
    fzf.files(opts)
end


M.files.cwd = file_cmd

M.files.home = function() file_cmd({ cwd = path.home() }) end

M.files.buffer_dir = function() file_cmd({ cwd = vim.fn.expand("%:p:h") }) end

M.files.nvim = function()
    file_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

M.files.org = function()
    file_cmd({
        cwd = join(path.home(), "dropbox", "org"),
        cmd = "fd --color=never --type f --hidden --follow --exclude .git | grep -v org_archive$"
    })
end

M.dirs.cwd = dir_cmd

M.dirs.home = function() dir_cmd({ cwd = path.home() }) end

M.dirs.buffer_dir = function() dir_cmd({ cwd = vim.fn.expand("%:p:h") }) end

M.dirs.nvim = function()
    dir_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

M.get_email = function()
    local khalrd_cmd = "khard --skip-unparsable email --parsable --remove-first-line"
    local sed_cmd = "sed 's/[ \\t].*$//'"
    local emails = vim.fn.system(khalrd_cmd .. " | " .. sed_cmd)
    fzf.fzf_exec(vim.split(emails, "\n"))
end

-- Based on fzf.actions.git_branch_add
M.git.branch_track = function(selected, opts)
    local branch = opts.last_query or selected[1]
    branch = string.gsub(branch, "^ *remotes/", "")
    if type(branch) ~= "string" or #branch == 0 then
        fzf.utils.warn("Branch name is empty.")
    else
        local cmd = fzf.path.git_cwd(opts.cmd_add, opts)
        table.insert(cmd, branch)
        local output, rc = fzf.utils.io_systemlist(cmd)
        if rc ~= 0 then
            fzf.utils.err("error for cmd: " .. table.concat(cmd, " "))
            fzf.utils.err(unpack(output))
        else
            fzf.utils.info(string.format("Created branch '%s'.", branch))
        end
    end
end

return M
