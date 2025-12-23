local fzf = require("fzf-lua")
local join = require("helpers.path").join
local path = require("helpers.path")
local M = {}

--- Remove non-printable ASCII characters from the provided text.
---@param text string
---@return string
local function strip_text(text)
    return text:gsub("[^\x20-\x7E]", "")
end

--- Insert the first selected entry into the current buffer.
---@param selected string|table|nil
---@return nil
local function insert_string(selected)
    if selected == nil or #selected == 0 then
        return
    elseif type(selected) == "table" then
        selected = selected[1]
    end
    selected = strip_text(selected)
    vim.api.nvim_put({ selected }, "", true, true)
end

--- Execute the fzf file picker with merged options.
---@param opts table|nil
---@return nil
local function file_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.files.opts, opts)
    fzf.files(opts)
end

--- Execute the fzf directory picker with merged options.
---@param opts table|nil
---@return nil
local function dir_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.dirs.opts, opts)
    fzf.files(opts)
end

--- Retrieve the first selection entry as a printable string.
---@param selected string|table|nil
---@return string|nil
local function select_first(selected)
    if selected == nil or #selected == 0 then
        return
    elseif type(selected) == "table" then
        selected = selected[1]
    end
    return strip_text(selected)
end

--- Open the selected file in a diff split window.
---@param selected string|table|nil
---@return nil
local function diffsplit(selected)
    vim.cmd("diffsplit " .. select_first(selected))
end

--- Insert a file path selected from the picker into the buffer.
---@param directory string|nil
---@return nil
local function insert_file(directory)
    directory = directory or vim.fn.getcwd()
    file_cmd({
        cwd = directory,
        actions = { ["enter"] = insert_string }
    })
end

--- Insert a directory path selected from the picker into the buffer.
---@param directory string|nil
---@return nil
local function insert_dir(directory)
    directory = directory or vim.fn.getcwd()
    dir_cmd({
        actions = { ["enter"] = insert_string }
    })
end

--- Extract a sanitized branch name from the selection.
---@param selected table
---@return string
local function strip_selected_branch(selected)
    local branch = string.gsub(selected[1], "^ *remotes/", "")
    branch = branch:match("^%s*(.-)%s*$")
    branch = branch:match("^(%S+)")
    if type(branch) ~= "string" or #branch == 0 then
        error("Branch name is empty.")
    else
        return branch
    end
end

--- Run a git subcommand and report success or failure.
---@param cmd table
---@param opts table|nil
---@param success_msg string|nil
---@return nil
local function git_call(cmd, opts, success_msg)
    if not cmd or #cmd == 0 then
        error("cmd is empty.")
    end
    cmd = fzf.path.git_cwd(cmd, opts)
    local output, rc = fzf.utils.io_systemlist(cmd)
    if rc ~= 0 then
        fzf.utils.error("error for cmd: " .. table.concat(cmd, " "))
        fzf.utils.error(unpack(output))
    elseif success_msg then
        fzf.utils.info(success_msg)
    end
end

M.files = {}
M.files.opts = {}
M.files.cwd = file_cmd

--- Browse files from the user's home directory.
---@return nil
function M.files.home()
    file_cmd({ cwd = path.home() })
end

--- Browse files relative to the current buffer directory.
---@return nil
function M.files.buffer_dir()
    file_cmd({ cwd = vim.fn.expand("%:p:h") })
end

--- Browse files within the Neovim configuration directory.
---@return nil
function M.files.nvim()
    file_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

--- Browse files within the org directory while excluding archives.
---@return nil
function M.files.org()
    file_cmd({
        cwd = join(path.home(), "dropbox", "org"),
        cmd = "fd --color=never --type f --hidden --follow --exclude .git | grep -v org_archive$"
    })
end

--- Browse files and open selections using a diff split.
---@return nil
function M.files.diffsplit()
    file_cmd({ actions = { enter = diffsplit } })
end

M.dirs = {}
M.dirs.opts = {
    prompt    = "Dirs❯ ",
    fd_opts   = "--type directory",
    previewer = false,
    git_icons = false,
    preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
}
M.dirs.cwd = dir_cmd

--- Browse directories from the user's home directory.
---@return nil
function M.dirs.home()
    dir_cmd({ cwd = path.home() })
end

--- Browse directories relative to the current buffer directory.
---@return nil
function M.dirs.buffer_dir()
    dir_cmd({ cwd = vim.fn.expand("%:p:h") })
end

--- Browse directories within the Neovim configuration directory.
---@return nil
function M.dirs.nvim()
    dir_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

--- Query email addresses from the address book for fzf selection.
---@return nil
function M.get_email()
    local khalrd_cmd = "khard --skip-unparsable email --parsable --remove-first-line"
    local sed_cmd = "sed 's/[ \\t].*$//'"
    local emails = vim.fn.system(khalrd_cmd .. " | " .. sed_cmd)
    fzf.fzf_exec(vim.split(emails, "\n"))
end

M.insert = {}
M.insert.files = {}
M.insert.files.cwd = insert_file

--- Insert a file path from the user's home directory.
---@return nil
function M.insert.files.home()
    insert_file(path.home())
end

M.insert.dirs = {}
M.insert.dirs.cwd = insert_dir

--- Insert a directory path from the user's home directory.
---@return nil
function M.insert.dirs.home()
    insert_dir(path.home())
end

M.git = {}

--- Check out a remote branch and set up tracking.
---@param selected table
---@param opts table|nil
---@return nil
function M.git.branch_track(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "switch", "-t" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Tracking branch '%s'.", branch))
end

--- Rebase the current branch onto the selected remote branch.
---@param selected table
---@param opts table|nil
---@return nil
function M.git.branch_rebase(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "rebase" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Rebased onto '%s'.", branch))
end

--- Merge the selected remote branch into the current branch.
---@param selected table
---@param opts table|nil
---@return nil
function M.git.branch_merge(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "merge" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Merged branch '%s'.", branch))
end

return M
