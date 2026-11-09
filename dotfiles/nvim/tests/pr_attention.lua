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
package.loaded["helpers.pr_inbox"] = { collect = function(success, failure) callbacks, on_error = success, failure end }
package.loaded["helpers.pr_attention"] = nil
local board = require("helpers.pr_attention")
board.open()
local buffer = vim.api.nvim_get_current_buf()
item = pr()
callbacks({ host = "github.com", login = "bart", updated_at = os.time(), prs = { item }, coverage = {} })
local function content() return table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n") end
local function action(key)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
        if mapping.lhs == key then return mapping.callback() end
    end
    error("Missing mapping: " .. key)
end
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
action("d")
assert(content():find("0 to inspect", 1, true), "Checking a snapshot completes its local queue item")
action("a")
assert(content():find("CHECKED", 1, true), "Checked items remain inspectable")
board.refresh()
on_error("Synthetic network failure")
assert(content():find("REFRESH FAILED", 1, true) and content():find("project#42", 1, true),
    "A failed refresh must preserve the previous snapshot")

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
assert(vim.wait(100, function() return vim.bo.filetype == "diff" end))
assert(compared[#compared]:find(string.rep("b", 40) .. "..." .. string.rep("c", 40), 1, true))
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("+new", 1, true))
vim.system = actual_system

vim.fn.delete(temporary, "rf")
print("PASS: review baselines, activity, deterministic fingerprints, account isolation, deferrals, persistence, and board actions")
