-- Run with: nvim --headless -u NONE -l dotfiles/tests/nvim/test_pr_inbox.lua
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local state = require("helpers.pr_inbox_state")
local sequence = 0
local function pr(overrides)
    sequence = sequence + 1
    return vim.tbl_extend("force", {
        number = sequence, title = "Example", url = "https://github.com/example/repo/pull/" .. sequence, state = "OPEN",
        repository = { nameWithOwner = "example/repo" }, headRefOid = "abc123",
        isDraft = false, isInMergeQueue = false, mergeable = "MERGEABLE",
        mergeStateStatus = "CLEAN", reviewDecision = "APPROVED",
        commits = { nodes = { { commit = { statusCheckRollup = { state = "SUCCESS" } } } } },
    }, overrides or {})
end
local function checks(value)
    return { nodes = { { commit = { statusCheckRollup = value } } } }
end
local cases = {
    { "ready", {} },
    { "drafts", { isDraft = true, reviewDecision = "CHANGES_REQUESTED" } },
    { "action", { reviewDecision = "CHANGES_REQUESTED" } },
    { "action", { commits = checks({ state = "FAILURE" }) } },
    { "action", { commits = checks({ state = "ERROR" }) } },
    { "action", { mergeable = "CONFLICTING" } },
    { "action", { mergeStateStatus = "DIRTY" } },
    { "waiting", { commits = checks({ state = "PENDING" }) } },
    { "waiting", { commits = checks({ state = "EXPECTED" }) } },
    { "waiting", { reviewDecision = "REVIEW_REQUIRED" } },
    { "waiting", { mergeStateStatus = "BLOCKED" } },
    { "waiting", { mergeStateStatus = "BEHIND" } },
    { "waiting", { mergeStateStatus = "UNKNOWN" } },
    { "waiting", { mergeable = "UNKNOWN" } },
    { "waiting", { mergeStateStatus = "UNSTABLE" } },
    { "waiting", { isInMergeQueue = true } },
    { "ready", { commits = checks(vim.NIL), reviewDecision = vim.NIL } },
    { "ready", { mergeStateStatus = "HAS_HOOKS" } },
}
for index, case in ipairs(cases) do
    assert(state.classify(pr(case[2])) == case[1], "Classification failed for case " .. index)
end

local real_system = vim.system
local requests, responses, notices, picked, opened = {}, {}, {}, nil, nil
package.loaded["octo.config"] = { values = { gh_cmd = "gh", gh_env = {} } }
package.loaded["octo.utils"] = {
    get_pull_request = function(number, repo) opened = { number, repo } end,
}
package.loaded["octo.pickers.fzf-lua.previewers"] = {
    issue = function(entries) return { entries = entries } end,
}
package.loaded["fzf-lua"] = { fzf_exec = function(lines, options)
    picked = options
    picked.colored_items = lines
    picked.items = vim.tbl_map(function(line) return (line:gsub("\27%[[%d;]*m", "")) end, lines)
end }
vim.notify = function(message, level) notices[#notices + 1] = { message, level } end
vim.system = function(command, options, callback)
    requests[#requests + 1] = { command = command, body = vim.json.decode(options.stdin) }
    local response = table.remove(responses, 1)
    assert(response, "Unexpected GitHub request")
    callback(response)
end
local function response(data)
    return { code = 0, stdout = vim.json.encode({ data = data }) }
end
local function page(nodes, more, cursor)
    return response({ search = {
        nodes = nodes, issueCount = #nodes,
        pageInfo = { hasNextPage = more or false, endCursor = cursor or vim.NIL },
    } })
end
local function combined(parts)
    local data = {}
    for source, result in pairs(parts) do
        data[source] = vim.json.decode(result.stdout).data.search
    end
    return response(data)
end
local function run(group, pages)
    requests, notices, picked, opened = {}, {}, nil, nil
    responses = {}
    local source_group = (group == "review" or group == "team") and group or "authored"
    for index, result in ipairs(pages) do
        local ok, body = pcall(vim.json.decode, result.stdout or "")
        if group ~= "all" and ok and body.data and body.data.search then
            local parts = { [source_group] = result }
            if index == 1 then
                for _, source_name in ipairs({ "review", "team", "authored" }) do
                    if source_name ~= source_group then parts[source_name] = page({}) end
                end
            end
            responses[#responses + 1] = combined(parts)
        else
            responses[#responses + 1] = result
        end
    end
    package.loaded["helpers.pr_inbox"] = nil
    require("helpers.pr_inbox").open(group)
    assert(vim.wait(1000, function() return #responses == 0 end), "Request did not complete")
    vim.wait(20, function() return false end)
end

-- Fetch all pages, remove duplicates, and classify before opening the picker.
run("action", {
    page({ pr(), pr({ number = 2, url = "https://github.com/example/repo/pull/2", reviewDecision = "CHANGES_REQUESTED" }) }, true, "page-2"),
    page({ pr({ number = 2, url = "https://github.com/example/repo/pull/2", reviewDecision = "CHANGES_REQUESTED" }),
        pr({ number = 3, url = "https://github.com/example/repo/pull/3", mergeable = "CONFLICTING" }) }),
})
assert(#requests == 2 and requests[2].body.variables.authoredAfter == "page-2", "Pagination was not followed")
assert(not vim.tbl_contains(requests[1].command, "--cache"), "Snapshot fetch did not request fresh data")
assert(#picked.items == 2, "Incorrect filtered or duplicate results")
local preview_entry = picked.previewer.entries[picked.items[1]]
assert(preview_entry.value == 2 and preview_entry.repo == "example/repo" and preview_entry.kind == "pull_request",
    "PR preview does not match the selected entry")
assert(requests[1].body.variables.authoredSearch:find("author:@me", 1, true), "Authored filter missing")
picked.actions.enter({ picked.items[1] })
assert(opened[1] == 2 and opened[2] == "example/repo", "Selected PR did not open in Octo")
picked.actions.enter({})
local copied, browser_url
vim.fn.setreg = function(register, value) copied = { register, value } end
vim.ui.open = function(url) browser_url = url end
picked.actions["ctrl-y"]({ picked.items[1] })
assert(copied[1] == "+" and copied[2] == "https://github.com/example/repo/pull/2", "URL copy failed")
picked.actions["ctrl-e"]({ picked.items[1] })
assert(copied[2] == "abc123", "SHA copy failed")
picked.actions["ctrl-b"]({ picked.items[1] })
assert(browser_url == "https://github.com/example/repo/pull/2", "Browser action failed")

run("review", { page({ pr({ reviewDecision = "REVIEW_REQUIRED" }) }) })
assert(requests[1].body.variables.reviewSearch:find("user-review-requested:@me", 1, true), "Direct review filter missing")
assert(#picked.items == 1, "Review picker incorrectly filters by authored state")
run("team", { page({ pr() }) })
assert(requests[1].body.variables.teamSearch:find("team-review-requested-user:@me", 1, true), "Team review filter missing")

run("drafts", { page({ pr({ isDraft = true }), pr() }) })
assert(#picked.items == 1 and picked.items[1]:find("%[Draft%]"), "Draft filter failed")
run("waiting", { page({ pr({ mergeable = "UNKNOWN" }), pr() }) })
assert(#picked.items == 1 and picked.items[1]:find("Merge state not confirmed"), "Unknown merge state was not retained")
run("ready", { page({ pr({ mergeStateStatus = "BLOCKED" }), pr() }) })
assert(#picked.items == 1 and picked.items[1]:find("Ready to merge"), "Blocked PR was marked ready")
run("ready", { page({}) })
assert(not picked and notices[#notices][1]:find("No PRs"), "Empty result was not reported")

-- API failures must not display partial results as a complete list.
run("action", {
    page({ pr({ reviewDecision = "CHANGES_REQUESTED" }) }, true, "page-2"),
    { code = 1, stderr = "Access denied" },
})
assert(not picked and notices[#notices][2] == vim.log.levels.ERROR, "API error did not stop the picker")
run("ready", { { code = 0, stdout = '{"errors":[{"message":"Permission denied"}]}' } })
assert(not picked and notices[#notices][1] == "Permission denied", "GraphQL error was not reported")
run("ready", { { code = 0, stdout = "invalid JSON" } })
assert(not picked and notices[#notices][2] == vim.log.levels.ERROR, "Invalid JSON was not reported")

-- The combined inbox is the union of all six groups, with every membership retained.
local direct = pr()
local team = pr()
local action = pr({ reviewDecision = "CHANGES_REQUESTED" })
local draft = pr({ isDraft = true })
local waiting = pr({ reviewDecision = "REVIEW_REQUIRED" })
local ready = pr()
run("all", {
    combined({
        review = page({ direct, action }),
        team = page({ direct, team }),
        authored = page({ draft, waiting, action }, true, "authored-2"),
    }),
    combined({ authored = page({ ready }) }),
})
assert(#picked.items == 6, "Combined inbox did not deduplicate all sources")
assert(#requests == 2 and requests[2].body.variables.authoredAfter == "authored-2", "Combined inbox lost pagination")
assert(requests[2].body.variables.reviewSearch == nil and requests[2].body.variables.teamSearch == nil,
    "Completed sources were fetched again")
assert(requests[1].body.variables.reviewSearch:find("user-review-requested:@me", 1, true)
    and requests[1].body.variables.teamSearch:find("team-review-requested-user:@me", 1, true)
    and requests[1].body.variables.authoredSearch:find("author:@me", 1, true), "Combined filters are incomplete")
assert(picked.items[1]:find("REVIEW") and picked.items[1]:find("TEAM"),
    "Overlapping review memberships were lost")
assert(picked.items[2]:find("REVIEW") and picked.items[2]:find("ACTION"),
    "Overlapping authored membership was lost")
for _, label in ipairs({ "DRAFT", "WAITING", "MERGE" }) do
    assert(table.concat(picked.items, "\n"):find(label, 1, true), "Combined inbox omitted " .. label)
end
picked.actions.enter({ picked.items[1] })
assert(opened[1] == direct.number and opened[2] == "example/repo", "Combined selection opened the wrong PR")
assert(picked.previewer.entries[picked.items[1]].value == direct.number, "Colored row lost its PR preview")
picked.actions.enter({ picked.colored_items[1] })
assert(opened[1] == direct.number, "ANSI colors broke PR selection")

-- Every shortcut filters the same warm snapshot without another request.
local shared_inbox = require("helpers.pr_inbox")
local shared_requests = #requests
for _, entry in ipairs({
    { "review", 2 }, { "team", 2 }, { "drafts", 1 }, { "waiting", 1 },
    { "action", 1 }, { "ready", 1 }, { "all", 6 },
}) do
    picked = nil
    shared_inbox.open(entry[1])
    assert(picked and #picked.items == entry[2], "Wrong snapshot membership for " .. entry[1])
    assert(#requests == shared_requests, "Warm shortcut fetched again: " .. entry[1])
    assert(picked.header:find("Snapshot:", 1, true), "Snapshot age missing for " .. entry[1])
end

-- Refreshing an individual list replaces the shared snapshot for all lists.
shared_inbox.open("action")
responses = { combined({ review = page({}), team = page({}), authored = page({ action }) }) }
picked.actions["ctrl-r"]()
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
assert(#requests == shared_requests + 1 and #picked.items == 1 and picked.prompt:find("Needs action", 1, true),
    "Individual refresh did not retain the selected filter")
shared_inbox.open("all")
assert(#requests == shared_requests + 1 and #picked.items == 1, "Individual refresh did not update the combined snapshot")

run("all", { combined({ review = page({}), team = page({}), authored = page({}) }) })
assert(#requests == 1, "A single-page combined inbox needs more than one request")
assert(not picked and notices[#notices][1]:find("No PRs"), "Empty combined inbox was not reported")
run("all", { combined({ review = page({ direct }), team = page({}), authored = page({}) }) })
responses = { combined({ review = page({ direct }), team = page({}), authored = page({}) }) }
picked.actions["ctrl-r"]()
assert(vim.wait(1000, function() return #responses == 0 end), "Forced refresh did not finish")
vim.wait(20, function() return false end)
assert(not vim.tbl_contains(requests[#requests].command, "--cache"), "Forced refresh used cached results")
run("all", {
    combined({ review = page({ direct }), team = page({}), authored = page({}, true, "more") }),
    { code = 1, stderr = "Access denied" },
})
assert(not picked and notices[#notices][2] == vim.log.levels.ERROR, "Incomplete combined inbox was displayed")

-- Startup prefetch fills the session snapshot without displaying a picker.
package.loaded["helpers.pr_inbox"] = nil
requests, notices, picked = {}, {}, nil
responses = { combined({ review = page({ direct }), team = page({}), authored = page({}) }) }
local inbox = require("helpers.pr_inbox")
inbox.prefetch()
assert(not picked, "Background prefetch opened a picker")
-- Opening while prefetch runs must join the same request.
inbox.open("all")
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
assert(#requests == 1 and picked and #picked.items == 1, "Foreground open duplicated the prefetch")
local request_count = #requests
picked = nil
inbox.open("all")
assert(picked and #requests == request_count, "A warm inbox did not open immediately")
inbox.prefetch()
assert(#requests == request_count, "Fresh snapshot triggered an unnecessary prefetch")

-- A stale snapshot is usable immediately while its replacement loads.
local real_time = os.time
os.time = function() return real_time() + 31 end
responses = { combined({ review = page({ team }), team = page({}), authored = page({}) }) }
inbox.open("all")
assert(picked.items[1]:find("#" .. direct.number .. " ", 1, true), "Stale snapshot did not open immediately")
assert(picked.header:find("background refresh requested", 1, true), "Snapshot refresh was not disclosed")
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
request_count = #requests
inbox.open("all")
assert(#requests == request_count and picked.items[1]:find("#" .. team.number .. " ", 1, true),
    "Background refresh did not update the next opening")
os.time = real_time

-- A host/account context change must not display the old snapshot.
local previous_host = vim.env.GH_HOST
vim.env.GH_HOST = "github.example.invalid"
responses = { combined({ review = page({ ready }), team = page({}), authored = page({}) }) }
picked = nil
inbox.open("all")
assert(not picked, "Another host's snapshot was reused")
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
assert(picked and picked.items[1]:find("#" .. ready.number .. " ", 1, true), "Changed host did not load its own data")
vim.env.GH_HOST = previous_host

-- A failed background request is quiet, and a later foreground open can retry.
package.loaded["helpers.pr_inbox"] = nil
requests, notices, picked = {}, {}, nil
responses = { { code = 1, stderr = "Offline" } }
inbox = require("helpers.pr_inbox")
inbox.prefetch()
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
assert(not picked and #notices == 0, "A background failure interrupted the editor")
responses = { combined({ review = page({ direct }), team = page({}), authored = page({}) }) }
inbox.open("all")
assert(vim.wait(1000, function() return #responses == 0 end))
vim.wait(20, function() return false end)
assert(picked and #requests == 2, "Failed prefetch blocked a foreground retry")

-- An interactive editor warms the inbox after startup and when focus returns.
local real_uis, real_defer = vim.api.nvim_list_uis, vim.defer_fn
local deferred, prefetches = nil, 0
vim.api.nvim_list_uis = function() return { {} } end
vim.defer_fn = function(callback) deferred = callback end
inbox.prefetch = function() prefetches = prefetches + 1 end
inbox.setup()
assert(deferred, "Interactive startup did not schedule a prefetch")
deferred()
vim.api.nvim_exec_autocmds("FocusGained", {})
assert(prefetches == 2, "Startup or focus prefetch was not triggered")
vim.api.nvim_del_augroup_by_name("PrInboxPrefetch")
vim.api.nvim_list_uis, vim.defer_fn = real_uis, real_defer

-- The plugin registers exactly the approved shortcuts and no old prefix.
local spec = dofile(root .. "/nvim/lua/plugins/octo.lua")
local keys = {}
for _, mapping in ipairs(spec.keys) do keys[#keys + 1] = mapping[1] end
assert(vim.deep_equal(keys, { "<leader>pp", "<leader>pr", "<leader>pt", "<leader>pd", "<leader>pw", "<leader>pa", "<leader>pm" }))
vim.system = real_system
print("PASS: PR inbox classification, pagination, filters, picker actions, errors, and mappings")
