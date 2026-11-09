local M = {}

local function present(value)
    return value ~= nil and value ~= vim.NIL
end

function M.last_review(pr, login)
    local latest
    for _, review in ipairs((pr.reviews or {}).nodes or {}) do
        if present(review.author) and review.author.login == login and present(review.submittedAt)
            and present(review.commit) and (not latest or review.submittedAt > latest.submittedAt) then
            latest = review
        end
    end
    return latest
end

local function canonical(value)
    if type(value) ~= "table" then return vim.json.encode(value) end
    local parts = {}
    if vim.islist(value) then
        for _, item in ipairs(value) do parts[#parts + 1] = canonical(item) end
        return "[" .. table.concat(parts, ",") .. "]"
    end
    local keys = vim.tbl_keys(value)
    table.sort(keys)
    for _, key in ipairs(keys) do parts[#parts + 1] = vim.json.encode(key) .. ":" .. canonical(value[key]) end
    return "{" .. table.concat(parts, ",") .. "}"
end

function M.fingerprint(pr)
    -- updatedAt is an activity signal, not proof of a reply needing a response.
    return vim.fn.sha256(canonical({ head = pr.headRefOid, activity = pr.updatedAt, decision = pr.reviewDecision,
        mergeable = pr.mergeable, merge_state = pr.mergeStateStatus, draft = pr.isDraft, checks = pr.commits,
        reviews = pr.reviews, comments = pr.comments, requests = pr.timelineItems, categories = pr.inbox_categories }))
end

function M.baseline(pr, login, checkpoint)
    local review = M.last_review(pr, login)
    if checkpoint and checkpoint.baseline_head
        and (not review or checkpoint.baseline_at >= review.submittedAt) then
        return checkpoint.baseline_head, "local checkpoint"
    end
    return review and review.commit.oid or nil, "submitted review"
end

function M.describe(pr, login, checkpoint, now)
    local categories = pr.inbox_categories or {}
    local own = present(pr.author) and pr.author.login == login
    local group = own and 4 or vim.tbl_contains(categories, "review") and 1
        or vim.tbl_contains(categories, "team") and 2 or 3
    local unchanged = checkpoint and checkpoint.fingerprint == M.fingerprint(pr)
    if unchanged then
        if checkpoint.snoozed_until and checkpoint.snoozed_until > (now or os.time()) then
            return group, "SNOOZED", "Deferred until " .. os.date("%Y-%m-%d", checkpoint.snoozed_until), true
        elseif not checkpoint.snoozed_until then
            return group, "CHECKED", "Unchanged since your checkpoint", true
        end
    end
    if own then
        local category, reason = require("helpers.pr_inbox_state").classify(pr)
        if category == "ready" then reason = "Merge candidate: inspect requirements" end
        if category ~= "action" and category ~= "ready" then
            if checkpoint and not unchanged then
                return group, "ACTIVITY", "Activity or checks changed since your checkpoint: inspect context", false
            end
            local since = checkpoint and checkpoint.checked_at or ""
            for _, review in ipairs((pr.reviews or {}).nodes or {}) do
                if present(review.author) and review.author.login ~= login and present(review.submittedAt)
                    and review.submittedAt > since then
                    return group, "ACTIVITY", "Reviewer activity: inspect whether a response is needed", false
                end
            end
            for _, comment in ipairs((pr.comments or {}).nodes or {}) do
                if present(comment.author) and comment.author.login ~= login and comment.updatedAt > since then
                    return group, "ACTIVITY", "PR comment: inspect whether a response is needed", false
                end
            end
        end
        return group, category == "action" and "ACTION" or category == "ready" and "MERGE?"
            or category == "drafts" and "DRAFT" or "WAITING", reason, category == "waiting"
    end
    local baseline, source = M.baseline(pr, login, checkpoint)
    if baseline and baseline ~= pr.headRefOid then
        return group, "UPDATED", "Code changed since " .. source, false
    elseif checkpoint then
        return group, "ACTIVITY", "Activity or check state changed: inspect context", false
    elseif baseline then
        return group, "REVIEWED", "Previously reviewed head: inspect requests and conversations", false
    end
    local incomplete = pr.reviews and pr.reviews.pageInfo and pr.reviews.pageInfo.hasPreviousPage
    return group, "NEW", incomplete and "No review found in recent history (history incomplete)"
        or "No previous review or checkpoint", false
end

local function checkpoint_path(host, login, url)
    for _, component in ipairs({ host, login }) do
        assert(type(component) == "string" and component:match("^[%w][%w._-]*$"), "Invalid account identity")
    end
    local root = vim.env.XDG_STATE_HOME or vim.fs.joinpath(vim.env.HOME, ".local", "state")
    return vim.fs.joinpath(root, "codex", "pr-attention", host, login, "checkpoints", vim.fn.sha256(url) .. ".json")
end

function M.read(host, login, url)
    local path = checkpoint_path(host, login, url)
    if not vim.uv.fs_stat(path) then return nil end
    local ok, record = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(path), "\n")) end)
    if not ok or type(record) ~= "table" or record.version ~= 1 or record.url ~= url
        or record.host ~= host or record.login ~= login or type(record.head) ~= "string"
        or type(record.checked_at) ~= "string" or type(record.fingerprint) ~= "string"
        or (record.baseline_head ~= nil and (type(record.baseline_head) ~= "string" or type(record.baseline_at) ~= "string"))
        or (record.snoozed_until ~= nil and type(record.snoozed_until) ~= "number") then
        return nil, "Invalid checkpoint preserved: " .. path
    end
    return record
end

function M.write(host, login, pr, snoozed_until)
    local path = checkpoint_path(host, login, pr.url)
    local previous, read_error = M.read(host, login, pr.url)
    if read_error then return nil, read_error end
    vim.fn.mkdir(vim.fs.dirname(path), "p", 448)
    local record = { version = 1, host = host, login = login, url = pr.url, head = pr.headRefOid,
        checked_at = os.date("!%Y-%m-%dT%H:%M:%SZ"), fingerprint = M.fingerprint(pr),
        snoozed_until = snoozed_until }
    if snoozed_until then
        record.baseline_head = previous and previous.baseline_head or nil
        record.baseline_at = previous and previous.baseline_at or nil
    else
        record.baseline_head, record.baseline_at = pr.headRefOid, record.checked_at
    end
    local temporary = path .. ".tmp-" .. vim.uv.os_getpid() .. "-" .. vim.uv.hrtime()
    local descriptor, err = vim.uv.fs_open(temporary, "wx", 384)
    if not descriptor then return nil, err end
    local encoded = vim.json.encode(record)
    local written, write_error = vim.uv.fs_write(descriptor, encoded, 0)
    vim.uv.fs_close(descriptor)
    if written ~= #encoded then
        vim.uv.fs_unlink(temporary)
        return nil, write_error or "Incomplete checkpoint write"
    end
    local renamed, rename_error = vim.uv.fs_rename(temporary, path)
    if not renamed then
        vim.uv.fs_unlink(temporary)
        return nil, rename_error
    end
    return record
end

function M.clear(host, login, url)
    local path = checkpoint_path(host, login, url)
    if not vim.uv.fs_stat(path) then return true end
    return vim.uv.fs_unlink(path)
end

return M
