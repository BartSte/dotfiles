local fzf = require("fzf-lua")
local join = require("helpers.path").join
local path = require("helpers.path")

---@class FzfHelpers
local M = {}

--- Run the fzf file picker with combined options.
---@param opts table<string, any>|nil
---@return nil
local function file_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.files.opts, opts)
    fzf.files(opts)
end

--- Run the fzf directory picker with combined options.
---@param opts table<string, any>|nil
---@return nil
local function dir_cmd(opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", M.dirs.opts, opts)
    fzf.files(opts)
end

---@class FzfFiles
M.files = {}

---@type table<string, any>
M.files.opts = {}
M.files.cwd = file_cmd

--- Open the file picker rooted at the user's home directory.
---@return nil
function M.files.home() file_cmd({ cwd = path.home() }) end

--- Open the file picker rooted at the current buffer's directory.
---@return nil
function M.files.buffer_dir() file_cmd({ cwd = vim.fn.expand("%:p:h") }) end

--- Open the file picker rooted at the Neovim configuration directory.
---@return nil
function M.files.nvim()
    file_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

--- Open the file picker rooted at the org directory.
---@return nil
function M.files.org()
    file_cmd({
        cwd = join(path.home(), "dropbox", "org"),
        cmd = "fd --color=never --type f --hidden --follow --exclude .git | grep -v org_archive$"
    })
end

--- Run diffsplit on the active buffer and the selected file.
--- @return nil
function M.files.diffsplit()
    local current_file = vim.fn.expand("%:p")
    file_cmd({
        actions = {
            ["enter"] = function(selected)
                if selected == nil or #selected == 0 then
                    return
                elseif type(selected) == "table" then
                    selected = selected[1]
                end
                vim.notify("Diffing " .. current_file .. " with " .. selected)
                vim.cmd("diffsplit " .. selected)
            end,
        },
        previewer = "cat --line-numbers {2} | delta --syntax-theme=Solarized --style=side-by-side",
        cmd = string.format(
            "fd --color=never --type f --hidden --follow --exclude .git --exclude %s",
            vim.fn.fnamemodify(current_file, ":t")
        ),
    })
end

---@class FzfDir
M.dirs = {}

---@type table<string, any>
M.dirs.opts = {
    prompt    = "Dirs❯ ",
    fd_opts   = "--type directory",
    previewer = false,
    git_icons = false,
    preview   = "exa --icons --color=always -T -L 1 -a {2} | head -200",
}

M.dirs.cwd = dir_cmd

--- Open the directory picker rooted at the user's home directory.
---@return nil
function M.dirs.home() dir_cmd({ cwd = path.home() }) end

--- Open the directory picker rooted at the current buffer's directory.
---@return nil
function M.dirs.buffer_dir() dir_cmd({ cwd = vim.fn.expand("%:p:h") }) end

--- Open the directory picker rooted at the Neovim configuration directory.
---@return nil
function M.dirs.nvim()
    dir_cmd({ cwd = join(path.home(), "dotfiles", "nvim") })
end

--- Select an email address from khard contacts.
---@return nil
function M.get_email()
    local khalrd_cmd = "khard --skip-unparsable email --parsable --remove-first-line"
    local sed_cmd = "sed 's/[ \\t].*$//'"
    local emails = vim.fn.system(khalrd_cmd .. " | " .. sed_cmd)
    fzf.fzf_exec(vim.split(emails, "\n"))
end

---@class FzfInsert
M.insert = {}

---@class FzfInsertFiles
M.insert.files = {}

--- Remove whitespace, newlines, and icons from the selected text.
---@param text string
---@return string
local function strip_text(text)
    return text:gsub("[^\x20-\x7E]", "")
end

--- Insert the selected string into the current buffer.
---@param selected string|string[]|nil
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

--- Select a file using fzf and insert it into the current buffer.
---@param directory string|nil The desired directory to start the search
---@return nil
local function insert_file(directory)
    directory = directory or vim.fn.getcwd()
    file_cmd({
        cwd = directory,
        actions = { ["enter"] = insert_string }
    })
end

M.insert.files.cwd = insert_file

--- Select a file from the home directory and insert it into the current buffer.
---@return nil
function M.insert.files.home() insert_file(path.home()) end

---@class FzfInsertDir
M.insert.dirs = {}

--- Select a directory using fzf and insert it into the current buffer.
---@param directory string|nil The desired directory to start the search
---@return nil
local function insert_dir(directory)
    directory = directory or vim.fn.getcwd()
    dir_cmd({
        actions = { ["enter"] = insert_string }
    })
end

M.insert.dirs.cwd = insert_dir

--- Select a directory from the home directory and insert it into the current buffer.
---@return nil
function M.insert.dirs.home() insert_dir(path.home()) end

---@class FzfGit
M.git = {}

--- Return the branch name from the selected branches.
---@param selected string[]
---@return string branch The branch name
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

---Run a git command.
---@param cmd string[] The command to run
---@param opts table<string, any>|nil The options
---@param success_msg string|nil The message to display on success
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

--- Track a branch.
---@param selected string[] The selected branches
---@param opts table<string, any>|nil The options
---@return nil
function M.git.branch_track(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "switch", "-t" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Tracking branch '%s'.", branch))
end

--- Rebase a branch.
---@param selected string[] The selected branches
---@param opts table<string, any>|nil The options
---@return nil
function M.git.branch_rebase(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "rebase" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Rebased onto '%s'.", branch))
end

--- Merge a branch.
---@param selected string[] The selected branches
---@param opts table<string, any>|nil The options
---@return nil
function M.git.branch_merge(selected, opts)
    local branch = strip_selected_branch(selected)
    local cmd = { "git", "merge" }
    table.insert(cmd, branch)
    git_call(cmd, opts, string.format("Merged branch '%s'.", branch))
end

return M
