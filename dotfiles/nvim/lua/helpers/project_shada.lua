local M = {}

---Use the main worktree's name so linked worktrees share the clone's ShaDa.
---@param cwd? string
---@return string
function M.path(cwd)
    cwd = cwd or vim.fn.getcwd()
    local project = cwd
    if vim.fn.executable("git") == 1 then
        local result = vim.system({ "git", "-C", cwd, "worktree", "list", "--porcelain", "-z" }):wait(2000)
        if result.code == 0 then
            -- Git lists the main worktree first. NUL delimiters preserve spaces
            -- and newlines in paths, including paths to linked worktrees.
            project = result.stdout:match("^worktree ([^%z]+)%z") or cwd
        end
    end
    local name = vim.fn.fnamemodify(project, ":t")
    return vim.fs.joinpath(vim.fn.stdpath("state"), "shada", name .. ".shada")
end

return M
