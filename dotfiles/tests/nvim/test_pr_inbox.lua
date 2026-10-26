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
    picked.items = lines
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
local function run(group, pages)
    requests, notices, picked, opened = {}, {}, nil, nil
    responses = { response({ viewer = { login = "example-user" } }) }
    vim.list_extend(responses, pages)
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
assert(#requests == 3 and requests[3].body.variables.after == "page-2", "Pagination was not followed")
assert(#picked.items == 2, "Incorrect filtered or duplicate results")
local preview_entry = picked.previewer.entries[picked.items[1]]
assert(preview_entry.value == 2 and preview_entry.repo == "example/repo" and preview_entry.kind == "pull_request",
    "PR preview does not match the selected entry")
assert(requests[2].body.variables.search:find("author:example%-user"), "Authored filter missing")
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
assert(requests[2].body.variables.search:find("user%-review%-requested:example%-user"), "Direct review filter missing")
assert(#picked.items == 1, "Review picker incorrectly filters by authored state")
run("team", { page({ pr() }) })
assert(requests[2].body.variables.search:find("team%-review%-requested%-user:example%-user"), "Team review filter missing")

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
    page({ direct, action }),
    page({ direct, team }),
    page({ draft, waiting, action }, true, "authored-2"),
    page({ ready }),
})
assert(#picked.items == 6, "Combined inbox did not deduplicate all sources")
assert(#requests == 5 and requests[5].body.variables.after == "authored-2", "Combined inbox lost pagination")
assert(picked.items[1]:find("Needs your review") and picked.items[1]:find("Needs your teams' review"),
    "Overlapping review memberships were lost")
assert(picked.items[2]:find("Needs your review") and picked.items[2]:find("Needs action"),
    "Overlapping authored membership was lost")
for _, label in ipairs({ "Your drafts", "Waiting for review or checks", "Ready to merge" }) do
    assert(table.concat(picked.items, "\n"):find(label, 1, true), "Combined inbox omitted " .. label)
end
picked.actions.enter({ picked.items[1] })
assert(opened[1] == direct.number and opened[2] == "example/repo", "Combined selection opened the wrong PR")
run("all", { page({}), page({}), page({}) })
assert(not picked and notices[#notices][1]:find("No PRs"), "Empty combined inbox was not reported")
run("all", { page({ direct }), { code = 1, stderr = "Access denied" } })
assert(not picked and notices[#notices][2] == vim.log.levels.ERROR, "Incomplete combined inbox was displayed")

-- The plugin registers exactly the approved shortcuts and no old prefix.
local spec = dofile(root .. "/nvim/lua/plugins/octo.lua")
local keys = {}
for _, mapping in ipairs(spec.keys) do keys[#keys + 1] = mapping[1] end
assert(vim.deep_equal(keys, { "<leader>pp", "<leader>pr", "<leader>pt", "<leader>pd", "<leader>pw", "<leader>pa", "<leader>pm" }))
vim.system = real_system
print("PASS: PR inbox classification, pagination, filters, picker actions, errors, and mappings")
