local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
package.loaded["octo.config"] = { values = { gh_cmd = "gh", github_hostname = "github.com" } }
local actual_system = vim.system
local requests, responses = {}, {}
local account = "bart"
vim.system = function(argv, options, callback)
    if argv[1] == "git" then return { wait = function() return { code = 0, stdout = account } end } end
    assert(argv[2] == "api" and argv[3] == "graphql", "Discovery must remain read-only")
    requests[#requests + 1] = vim.json.decode(options.stdin)
    responses[#responses + 1] = callback
end
local function item(number, author)
    return { url = "https://github.com/example/project/pull/" .. number, number = number, state = "OPEN",
        author = { login = author or "colleague" }, repository = { nameWithOwner = "example/project" } }
end
local function connection(nodes, next_page, count)
    return { nodes = nodes, pageInfo = { hasNextPage = next_page or false, endCursor = "cursor" },
        issueCount = count or #nodes }
end
local inbox = require("helpers.pr_inbox")
local result, failure
inbox.collect(function(value) result = value end, function(message) failure = message end)
assert(requests[1].variables.reviewedSearch:find("reviewed%-by:@me"))
assert(requests[1].variables.reviewSearch:find("%-author:@me"))
responses[1]({ code = 0, stdout = vim.json.encode({ data = { viewer = { login = "bart" },
    review = connection({ item(1) }, true), authored = connection({ item(2, "bart") }),
    team = connection({ item(1) }), reviewed = connection({ item(3) }) } }) })
assert(vim.wait(100, function() return #requests == 2 end), "Unfinished sources must paginate")
assert(requests[2].variables.reviewAfter == "cursor" and requests[2].variables.teamSearch == nil)
responses[2]({ code = 0, stdout = vim.json.encode({ data = { viewer = { login = "bart" }, review = connection({ item(4) }) } }) })
assert(vim.wait(100, function() return result ~= nil end))
assert(result.login == "bart" and #result.prs == 4, "Sources must deduplicate canonical PR URLs")
assert(failure == nil, "Successful discovery must not call the error handler")
assert(vim.tbl_contains(result.prs[1].inbox_categories, "review") and vim.tbl_contains(result.prs[1].inbox_categories, "team"))

inbox.collect(function() error("An account change must not publish the old account's results") end,
    function(message) failure = message end)
account = "other-account"
responses[3]({ code = 0, stdout = vim.json.encode({ data = { viewer = { login = "bart" },
    review = connection({}), authored = connection({}), team = connection({}), reviewed = connection({}) } }) })
assert(vim.wait(100, function() return failure ~= nil end), "Account changes must release waiting callers")
assert(failure:find("context changed", 1, true))
failure = nil
inbox.collect(function() error("Failed discovery must not publish an empty queue") end,
    function(message) failure = message end)
responses[4]({ code = 1, stderr = "Synthetic network failure" })
assert(vim.wait(100, function() return failure ~= nil end))
assert(failure == "Synthetic network failure")
vim.system = actual_system
print("PASS: read-only discovery, pagination, deduplication, follow-up coverage, and account changes")
