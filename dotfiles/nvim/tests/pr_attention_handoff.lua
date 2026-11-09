local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
local temporary = vim.fn.tempname()
local directory = temporary .. "/worktree with spaces"
vim.fn.mkdir(directory, "p")
vim.env.XDG_STATE_HOME, vim.env.TMUX = temporary, "test-tmux"
local pr = { url = "https://github.com/example/project/pull/42", number = 42, title = "Example",
    repository = { nameWithOwner = "example/project" }, author = { login = "colleague" },
    headRefOid = string.rep("b", 40), inbox_categories = { "review" } }
package.loaded["helpers.pr_inbox"] = { collect = function(callback)
    callback({ host = "github.com", login = "bart", updated_at = os.time(), prs = { pr }, coverage = {} })
end }
package.loaded["octo.config"] = { values = { gh_cmd = "gh" } }
local actual_system, actual_executable = vim.system, vim.fn.executable
vim.fn.executable = function() return 1 end
local calls, deliveries, fail_preparation, stale = {}, 0, false, false
package.loaded["helpers.codex"] = { send = function(payload, options)
    assert(#calls == 3 and calls[3][1] == "tsp", "Open the worktree session before inserting the prompt")
    assert(options.directory == directory and options.focus and options.wait_ms > 0)
    assert(payload:find(pr.url, 1, true) and payload:find(pr.headRefOid, 1, true))
    assert(payload:find("$pr-post", 1, true) and payload:find("before approval", 1, true))
    deliveries = deliveries + 1
end }
vim.system = function(argv, _, callback)
    calls[#calls + 1] = argv
    local result = { code = 0, stderr = "", stdout = "" }
    if argv[1] == "gh" then
        result.stdout = vim.json.encode({ headRefOid = stale and string.rep("c", 40) or pr.headRefOid,
            baseRefName = "main", headRefName = "feature/review" })
    elseif argv[1] == "tsp-pr" then
        assert(argv[2] == "--prepare-only" and argv[3] == "--expected-head" and argv[4] == pr.headRefOid)
        result.code = fail_preparation and 1 or 0
        result.stderr = fail_preparation and "Synthetic worktree update failure" or ""
        result.stdout = directory .. "\n"
    elseif argv[1] == "tsp" then
        assert(argv[2] == directory)
    else error("Unexpected command: " .. argv[1]) end
    callback(result)
end
local queue = require("helpers.pr_attention")
queue.open()
local buffer = vim.api.nvim_get_current_buf()
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
local function action(key)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
        if mapping.lhs == key then return mapping.callback() end
    end
    error("Missing mapping: " .. key)
end
action("c")
action("c")
assert(vim.wait(1000, function() return deliveries == 1 end), "A repeated key must not create duplicate handoffs")
assert(#calls == 3)

calls, fail_preparation = {}, true
action("c")
vim.wait(100)
assert(#calls == 2 and deliveries == 1, "Failed preparation must not open a session or insert a prompt")

calls, fail_preparation, stale = {}, false, true
action("c")
vim.wait(100)
assert(#calls == 1 and deliveries == 1, "A stale head must stop before worktree changes or prompt insertion")

calls, stale = {}, false
action("w")
assert(vim.wait(1000, function() return #calls == 3 end))
vim.wait(20)
assert(deliveries == 1, "The worktree-only action must not insert a prompt")
vim.system, vim.fn.executable = actual_system, actual_executable
vim.fn.delete(temporary, "rf")
print("PASS: queue handoff order, exact PR context, duplicate keys, preparation failures, stale heads, and worktree-only action")
