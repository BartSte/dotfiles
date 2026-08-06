local M = {}

local title = "Octo PR project"

---Update, check out, and open the tmux project for the current Octo PR.
---@return nil
function M.open_pr_project()
    if not vim.env.TMUX or vim.env.TMUX == "" then
        vim.notify("Neovim must be running inside tmux so tsp can switch the active client.", vim.log.levels.ERROR,
            { title = title })
        return
    end

    local octo_utils = require("octo.utils")
    local buffer = octo_utils.get_current_buffer()

    if not buffer or not buffer:isPullRequest() then
        vim.notify("This shortcut requires an open Octo PR.", vim.log.levels.ERROR, { title = title })
        return
    end

    local pull_request = buffer:pullRequest()
    local repo = pull_request.baseRepository and pull_request.baseRepository.nameWithOwner
    local base_branch = pull_request.baseRefName
    local head_branch = pull_request.headRefName
    local pr_number = pull_request.number or buffer.number

    if not repo or not base_branch or not head_branch or not pr_number then
        vim.notify("The current PR does not contain complete repository and branch data.", vim.log.levels.ERROR,
            { title = title })
        return
    end

    local command = { "tsp-pr", repo, tostring(pr_number), base_branch, head_branch }
    vim.notify(string.format("Opening %s#%s (%s)...", repo, pr_number, head_branch), vim.log.levels.INFO,
        { title = title })

    vim.system(command, { cwd = vim.fn.getcwd(), text = true }, function(result)
        if result.code == 0 then
            return
        end

        vim.schedule(function()
            local stderr = vim.trim(result.stderr or "")
            local stdout = vim.trim(result.stdout or "")
            local message = stderr ~= "" and stderr or stdout
            if message == "" then
                message = string.format("tsp-pr exited with status %d.", result.code)
            end
            vim.notify(message, vim.log.levels.ERROR, { title = title })
        end)
    end)
end

return M
