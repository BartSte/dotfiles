local fzf = require("fzf-lua")
local join = require("helpers.path").join
local path = require("helpers.path")

---@class FzfHelpers
---@field files FzfFiles
---@field dirs FzfDir
---@field git FzfGit
local M = {}

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

---@class FzfFiles
---@field opts table
---@field cwd fun(opts: table): nil
---@field home fun(): nil
---@field buffer_dir fun(): nil
---@field nvim fun(): nil
---@field org fun(): nil
M.files = {}
M.files.opts = {}
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

---@class FzfDir
---@field opts table
---@field cwd fun(opts: table): nil
---@field home fun(): nil
M.dirs = {}
M.dirs.opts = {
    prompt    = "Dirs❯ ",
    fd_opts   = "--type directory",
    previewer = false,
    git_icons = false,
    preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
}

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

---@class FzfGit
---@field branch_track fun(selected: table, opts: table): nil
---@field branch_rebase fun(selected: table, opts: table): nil
---@field branch_merge fun(selected: table, opts: table): nil
M.git = {}

--- Return the branch name from the selected branches
---@param selected table The selected branches
---@return string branch The branch name
local function strip_selected_branch(selected)
    local branch = string.gsub(selected[1], "^ *remotes/", "")
    branch = string.gsub(branch, "%s+", "")
    if type(branch) ~= "string" or #branch == 0 then
        error("Branch name is empty.")
    else
        return branch
    end
end

---Run a git command
---@param cmd table The command to run
---@param opts table The options
---@param success_msg string? The message to display on success
---@return nil
local function git_call(cmd, opts, success_msg)
    if not cmd or #cmd == 0 then
        error("cmd is empty.")
    end
    cmd = fzf.path.git_cwd(cmd, opts)
    local output, rc = fzf.utils.io_systemlist(cmd)
    if rc ~= 0 then
        fzf.utils.err("error for cmd: " .. table.concat(cmd, " "))
        fzf.utils.err(unpack(output))
    elseif success_msg then
        fzf.utils.info(success_msg)
    end
end

--- Track a branch
---@param selected table The selected branches
---@param opts table The options
---@return nil
M.git.branch_track = function(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "switch", "-t" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Tracking branch '%s'.", branch))
end

--- Rebase a branch
---@param selected table The selected branches
---@param opts table The options
---@return nil
M.git.branch_rebase = function(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "rebase" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Rebased onto '%s'.", branch))
end

--- Merge a branch
---@param selected table The selected branches
---@param opts table The options
---@return nil
M.git.branch_merge = function(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "merge" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Merged branch '%s'.", branch))
end

return M
