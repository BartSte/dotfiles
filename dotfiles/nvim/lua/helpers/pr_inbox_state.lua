local M = {}

local function present(value)
    return value ~= nil and value ~= vim.NIL
end

---Assign each authored PR to one inbox group. Unknown state stays in waiting.
---@param pr table
---@return string group
---@return string reason
function M.classify(pr)
    if pr.isDraft then
        return "drafts", "Draft"
    end

    local commits = pr.commits and pr.commits.nodes or {}
    local commit = commits[1] and commits[1].commit
    local rollup = commit and commit.statusCheckRollup
    local checks = present(rollup) and rollup.state or nil

    if pr.reviewDecision == "CHANGES_REQUESTED" then
        return "action", "Changes requested"
    end
    if checks == "FAILURE" or checks == "ERROR" then
        return "action", "Checks failed"
    end
    if pr.mergeable == "CONFLICTING" or pr.mergeStateStatus == "DIRTY" then
        return "action", "Merge conflicts"
    end
    if pr.isInMergeQueue then
        return "waiting", "In merge queue"
    end

    local clean = pr.mergeStateStatus == "CLEAN" or pr.mergeStateStatus == "HAS_HOOKS"
    if clean and pr.mergeable == "MERGEABLE" and pr.reviewDecision ~= "REVIEW_REQUIRED"
        and (checks == nil or checks == "SUCCESS") then
        return "ready", "Ready to merge"
    end
    if checks == "PENDING" or checks == "EXPECTED" then
        return "waiting", "Checks pending"
    end
    if pr.reviewDecision == "REVIEW_REQUIRED" then
        return "waiting", "Review required"
    end
    if pr.mergeStateStatus == "BEHIND" then
        return "waiting", "Branch behind base"
    end
    if pr.mergeStateStatus == "BLOCKED" then
        return "waiting", "Merge requirements not satisfied"
    end
    return "waiting", "Merge state not confirmed"
end

return M
