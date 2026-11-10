local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
local memory = require("helpers.pr_attention_state")
local temporary = vim.fn.tempname()
vim.env.XDG_STATE_HOME = temporary

local function pr()
    return { url = "https://github.com/example/project/pull/42", number = 42, title = "Example",
        repository = { nameWithOwner = "example/project" }, author = { login = "colleague" },
        headRefOid = string.rep("b", 40), updatedAt = "2026-11-06T10:00:00Z", isDraft = false,
        inbox_categories = { "review", "followup" }, reviews = { nodes = {
            { author = { login = "bart" }, state = "COMMENTED", submittedAt = "2026-11-05T10:00:00Z",
                commit = { oid = string.rep("a", 40) } },
        } } }
end

local item = pr()
local group, status = memory.describe(item, "bart")
assert(group == 1 and status == "UPDATED", "Submitted reviews establish the initial baseline")
local record = assert(memory.write("github.com", "bart", item))
assert(record.baseline_head == item.headRefOid)
local stored = assert(memory.read("github.com", "bart", item.url))
assert(select(2, memory.describe(item, "bart", stored)) == "CHECKED")
assert(not memory.read("github.com", "someone-else", item.url), "Accounts cannot share checkpoints")
assert(not memory.read("enterprise.example", "bart", item.url), "Hosts cannot share checkpoints")

local reordered = vim.json.decode(vim.json.encode(item))
assert(memory.fingerprint(reordered) == record.fingerprint, "Fingerprint survives JSON round trips")
reordered.title = "An unrelated title edit"
assert(memory.fingerprint(reordered) == record.fingerprint, "Unrelated fields alone do not invalidate a checkpoint")

item.updatedAt = "2026-11-06T11:00:00Z"
assert(select(2, memory.describe(item, "bart", stored)) == "ACTIVITY", "Feedback can change at an unchanged head")
item.headRefOid = string.rep("c", 40)
assert(select(2, memory.describe(item, "bart", stored)) == "UPDATED")
local deferred = assert(memory.write("github.com", "bart", item, os.time() + 3600))
assert(select(2, memory.describe(item, "bart", deferred)) == "SNOOZED")
assert(memory.baseline(item, "bart", deferred) == stored.baseline_head, "Deferral must not advance the assessed head")
assert(select(2, memory.describe(item, "bart", deferred, os.time() + 7200)) == "UPDATED", "Due deferrals become eligible")
item.updatedAt = "2026-11-06T12:00:00Z"
assert(select(2, memory.describe(item, "bart", deferred)) ~= "SNOOZED", "New activity ends a deferral")

assert(memory.clear("github.com", "bart", item.url))
local no_assessment = assert(memory.write("github.com", "bart", item, os.time() + 3600))
assert(memory.baseline(item, "bart", no_assessment) == string.rep("a", 40), "Snoozing alone is not an assessment")

item.author.login = "bart"
assert(memory.describe(item, "bart") == 4, "Own PRs come after colleague review work")
item.reviews.nodes = {}
item.comments = { nodes = { { author = { login = "reviewer" }, updatedAt = "2026-11-06T11:00:00Z" } } }
assert(select(2, memory.describe(item, "bart")) == "ACTIVITY", "Ordinary comments on authored PRs cannot be hidden as waiting")
item.comments.nodes = {}
item.reviews.nodes = { { author = { login = "reviewer" }, state = "COMMENTED", submittedAt = "2026-11-06T11:00:00Z" } }
assert(select(2, memory.describe(item, "bart")) == "ACTIVITY", "COMMENTED reviews need inspection without CHANGES_REQUESTED")

-- Exercise the board through its real buffer mappings, with synthetic read-only discovery.
local callbacks, on_error
local notifications, actual_notify = {}, vim.notify
vim.notify = function(message, level, options)
    notifications[#notifications + 1] = { message = message, level = level, options = options }
end
package.loaded["helpers.pr_inbox"] = { collect = function(success, failure) callbacks, on_error = success, failure end }
package.loaded["helpers.pr_attention"] = nil
local board = require("helpers.pr_attention")
board.open()
local buffer = vim.api.nvim_get_current_buf()
local function content() return table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n") end
local initial_notice = notifications[#notifications]
assert(initial_notice.message == "Loading PR queue..." and initial_notice.options.timeout == false)
local notification_count = #notifications
board.refresh()
assert(#notifications == notification_count + 1
    and notifications[#notifications].options.id ~= initial_notice.options.id,
    "A repeated refresh must explain the busy state without replacing the loader")
assert(not content():find("Loading", 1, true), "Loading belongs in notifications, not the board")
on_error("Synthetic initial failure")
assert(notifications[#notifications].level == vim.log.levels.ERROR)
assert(not notifications[#notifications].message:find("previous snapshot", 1, true),
    "An initial failure must not claim that a previous snapshot exists")
board.refresh()
item = pr()
callbacks({ host = "github.com", login = "bart", updated_at = os.time(), prs = { item }, coverage = {} })
local completed_notice = notifications[#notifications]
assert(completed_notice.options.id == initial_notice.options.id and completed_notice.options.timeout ~= false,
    "A successful refresh must replace the persistent loader with a temporary result")
local function action(key)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
        if mapping.lhs == key then return mapping.callback() end
    end
    error("Missing mapping: " .. key)
end
vim.api.nvim_win_set_cursor(0, { 1, 0 })
local before_invalid_action = content()
action("d")
assert(content() == before_invalid_action and notifications[#notifications].message:find("No PR selected", 1, true),
    "An action on the header must explain why it did nothing")
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
action("d")
assert(content():find("0 to inspect", 1, true), "Checking a snapshot completes its local queue item")
action("a")
assert(content():find("", 1, true), "Checked items remain inspectable with their status icon")
assert(notifications[#notifications].message == "Showing all PRs.", "The filter key must acknowledge the new state")
board.refresh()
assert(not content():find("refreshing", 1, true), "Refresh progress must not alter the board")
local previous_content = content()
action("d")
assert(content() == previous_content and notifications[#notifications].message:find("still loading", 1, true),
    "PR actions during refresh must explain why they cannot run")
on_error("Synthetic network failure")
assert(content() == previous_content, "A failed refresh must preserve the previous board")
local failed_notice = notifications[#notifications]
assert(failed_notice.message:find("Synthetic network failure", 1, true)
    and failed_notice.level == vim.log.levels.ERROR
    and failed_notice.options.id == initial_notice.options.id and failed_notice.options.timeout ~= false,
    "A failed refresh must replace the persistent loader with an error notification")

-- A changed head must produce a terminal comparison against the saved assessment.
item.headRefOid = string.rep("c", 40)
board.refresh()
callbacks({ host = "github.com", login = "bart", updated_at = os.time(), prs = { item }, coverage = {} })
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
local actual_system = vim.system
package.loaded["octo.config"] = { values = { gh_cmd = "gh" } }
local compared
vim.system = function(argv, _, callback)
    compared = argv
    callback({ code = 0, stdout = vim.json.encode({ status = "ahead", files = {
        { filename = "example.lua", patch = "@@ -1 +1 @@\n-old\n+new" },
    } }) })
end
action("D")
assert(notifications[#notifications].message:find("Loading changes", 1, true),
    "The changes key must acknowledge the request before the asynchronous result")
assert(vim.wait(100, function() return vim.bo.filetype == "diff" end))
assert(compared[#compared]:find(string.rep("b", 40) .. "..." .. string.rep("c", 40), 1, true))
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("+new", 1, true))
vim.system = actual_system
vim.notify = actual_notify

-- Selection details must not move PR rows or intercept normal cursor movement.
vim.api.nvim_set_current_buf(buffer)
local second = pr()
second.url, second.number, second.reviews = "https://github.com/example/project/pull/43", 43, { nodes = {} }
item.baseRefName, item.reviewDecision = "develop", "APPROVED"
item.commits = { nodes = { { commit = { statusCheckRollup = { state = "SUCCESS" } } } } }
second.commits = { nodes = { { commit = { statusCheckRollup = vim.NIL } } } }
board.refresh()
callbacks({ host = "github.com", login = "bart", updated_at = os.time(), prs = { item, second }, coverage = {} })
local function details()
    return vim.api.nvim_buf_get_extmarks(buffer, vim.api.nvim_create_namespace("PrAttentionDetails"),
        0, -1, { details = true })
end
local positions = {}
for line, value in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if value:find("project#42", 1, true) then positions[1] = line end
    if value:find("project#43", 1, true) then positions[2] = line end
end
local stable_content = content()
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", { buffer = buffer })
assert(#details() == 0, "Ordinary details stay hidden when no PR is selected")
for _, line in ipairs(positions) do
    vim.api.nvim_win_set_cursor(0, { line, 0 })
    vim.api.nvim_exec_autocmds("CursorMoved", { buffer = buffer })
    local marks = details()
    assert(#marks == 1 and marks[1][2] == line - 1, "Only the selected PR must show ordinary details")
    assert(content() == stable_content and vim.api.nvim_win_get_cursor(0)[1] == line,
        "Selection details must preserve buffer rows and cursor position")
    local text = vim.inspect(marks[1][4].virt_lines)
    if line == positions[1] then
        assert(text:find("@colleague", 1, true) and text:find("develop", 1, true)
            and text:find("CI passed", 1, true) and text:find("approved", 1, true),
            "Selected details must show the author, base branch, CI result, and review state")
    else
        assert(text:find("CI not reported", 1, true) and not text:find("CI passed", 1, true),
            "Missing CI metadata must never imply success")
    end
end

vim.fn.delete(temporary, "rf")
print("PASS: review baselines, activity, deterministic fingerprints, account isolation, deferrals, persistence, and board actions")
