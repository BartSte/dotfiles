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
local conflict_callback, conflict_prompt, mergeable, output_path
local merge_present, unresolved = false, ""
local current_head, remote_head = pr.headRefOid, pr.headRefOid
local commits, pushes = 0, 0
package.loaded["helpers.codex"] = { send = function(payload, options)
    assert(#calls == 3 and calls[3][1] == "tsp", "Open the worktree session before inserting the prompt")
    assert(options.directory == directory and options.focus and options.wait_ms > 0)
    assert(payload:find(pr.url, 1, true) and payload:find(pr.headRefOid, 1, true))
    assert(payload:find("$pr-post", 1, true) and payload:find("before approval", 1, true))
    deliveries = deliveries + 1
end }
vim.system = function(argv, _, callback)
    if argv[1] == "git" then
        local result = { code = 0, stdout = "", stderr = "" }
        if argv[4] == "rev-parse" then
            if argv[5] == "HEAD" then result.stdout = current_head .. "\n"
            else result.code, result.stdout = merge_present and 0 or 1, merge_present and string.rep("c", 40) or "" end
        elseif argv[4] == "diff" and argv[5] == "--name-only" then result.stdout = unresolved
        elseif argv[4] == "commit" then
            commits = commits + 1
            current_head, merge_present = string.rep("d", 40), false
        elseif argv[4] == "push" then
            assert(not vim.tbl_contains(argv, "--force"))
            assert(argv[#argv] == current_head .. ":refs/heads/feature/review")
            pushes, remote_head = pushes + 1, current_head
        end
        if callback then callback(result) end
        return { wait = function() return result end }
    end
    calls[#calls + 1] = argv
    local result = { code = 0, stderr = "", stdout = "" }
    if argv[1] == "gh" then
        result.stdout = vim.json.encode({ headRefOid = stale and string.rep("c", 40) or remote_head,
            baseRefName = "main", headRefName = "feature/review", author = pr.author,
            headRepository = { name = "project" }, headRepositoryOwner = { login = "example" },
            state = "OPEN", mergeable = mergeable or "CONFLICTING" })
    elseif argv[1] == "tsp-pr" then
        assert(argv[2] == "--prepare-only" and argv[3] == "--expected-head" and argv[4] == pr.headRefOid)
        result.code = fail_preparation and 1 or 0
        result.stderr = fail_preparation and "Synthetic worktree update failure" or ""
        result.stdout = directory .. "\n"
    elseif argv[1] == "tsp" then
        assert(argv[2] == directory)
    elseif argv[1] == "codex" then
        assert(argv[2] == "exec" and argv[3] == "--cd" and argv[4] == directory)
        output_path = argv[vim.fn.index(argv, "--output-last-message") + 2]
        assert(vim.fn.filereadable(output_path) == 1, "Codex must save its final response outside the worktree")
        conflict_prompt, conflict_callback = argv[#argv], callback
        return
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

-- Conflict resolution starts its own task and never uses a colleague's PR.
calls = {}
action("m")
assert(#calls == 0, "Conflict resolution must reject PRs by other authors")
pr.author.login = "bart"
mergeable = "MERGEABLE"
action("m")
vim.wait(50)
assert(#calls == 1, "A PR without conflicts must not start a worktree or a Codex task")

calls, mergeable = {}, "CONFLICTING"
vim.env.TMUX = nil
action("m")
action("m")
assert(vim.wait(1000, function() return conflict_callback ~= nil end))
assert(#calls == 3 and calls[3][1] == "codex" and deliveries == 1,
    "Resolve conflicts without opening or switching to a tmux session")
assert(vim.api.nvim_get_current_buf() == buffer, "Starting conflict resolution must preserve focus")
assert(conflict_prompt:find(pr.url, 1, true) and conflict_prompt:find(pr.headRefOid, 1, true))
assert(conflict_prompt:find("--no-commit --no-ff", 1, true)
    and conflict_prompt:find("Do not commit, push", 1, true), "Resolutions must remain local and uncommitted")
action("m")
assert(#calls == 3, "Repeated keys must not start concurrent conflict tasks for one PR")
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("still running", 1, true))
vim.cmd("close")
conflict_callback({ code = 1, stdout = "", stderr = "Synthetic conflict task failure" })
assert(vim.wait(1000, function()
    return table.concat(vim.fn.readfile(output_path:gsub("%.output$", "")), "\n"):find("Task exit code: 1", 1, true) ~= nil
end))
assert(vim.api.nvim_get_current_buf() == buffer, "Task completion must not steal focus")
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Synthetic conflict task failure", 1, true))
vim.cmd("close")
conflict_callback, calls = nil, {}
action("m")
assert(vim.wait(1000, function() return conflict_callback ~= nil end), "A failed task must allow retry")
vim.fn.writefile({ "Resolved example.lua. No commit or push." }, output_path)
merge_present = true
conflict_callback({ code = 0, stdout = "", stderr = "" })
assert(vim.wait(1000, function()
    return table.concat(vim.fn.readfile(output_path:gsub("%.output$", "")), "\n"):find("Task exit code: 0", 1, true) ~= nil
end))
assert(vim.api.nvim_get_current_buf() == buffer)
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Resolved example.lua", 1, true))
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Ready for review", 1, true))
vim.cmd("close")
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Resolved example.lua", 1, true),
    "A closed report must remain available on disk")
vim.cmd("close")
vim.api.nvim_buf_delete(buffer, { force = true })
package.loaded["helpers.pr_attention"] = nil
queue = require("helpers.pr_attention")
queue.open()
buffer = vim.api.nvim_get_current_buf()
action("a")
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Resolved example.lua", 1, true),
    "Reports must survive a fresh module instance without in-memory task state")

-- A zero exit code with Git conflicts must need a decision and support resume.
vim.cmd("close")
unresolved = "policy.html\n"
action("M")
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("Needs a decision", 1, true))
local function report_action(key)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(0, "n")) do
        if mapping.lhs == key then return mapping.callback() end
    end
    error("Missing report mapping: " .. key)
end
local original_input, original_select = vim.ui.input, vim.ui.select
vim.ui.input = function(_, callback) callback("Use policy version 5.") end
conflict_callback = nil
local before_resume = #calls
report_action("m")
assert(vim.wait(1000, function() return conflict_callback ~= nil end))
assert(#calls == before_resume + 2, "Resuming must use fresh metadata and Codex without preparing or replacing the worktree")
assert(conflict_prompt:find("Use policy version 5.", 1, true)
    and conflict_prompt:find("Resume the existing local merge", 1, true))
vim.fn.writefile({ "Policy version needs a decision." }, output_path)
conflict_callback({ code = 0, stdout = "", stderr = "" })
assert(vim.wait(1000, function()
    return table.concat(vim.fn.readfile(output_path:gsub("%.output$", "") .. ".json"), "\n"):find("Needs a decision", 1, true) ~= nil
end), "Exit zero with unresolved files must not report readiness")

-- Local review, commit, and push require separate explicit confirmations.
unresolved = ""
vim.api.nvim_set_current_buf(buffer)
for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
    if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); break end
end
action("M")
vim.ui.select = function(_, _, callback) callback("Cancel", 1) end
report_action("c")
vim.wait(50)
assert(commits == 0 and pushes == 0, "Cancelling review must not commit or push")
vim.ui.select = function(choices, _, callback) callback(choices[2], 2) end
report_action("c")
assert(vim.wait(1000, function() return commits == 1 end))
assert(vim.wait(1000, function()
    return table.concat(vim.fn.readfile(output_path:gsub("%.output$", "") .. ".json"), "\n"):find("Committed locally", 1, true) ~= nil
end))
assert(pushes == 0, "A local commit must not push automatically")
report_action("p")
assert(vim.wait(1000, function() return pushes == 1 end))
vim.ui.input, vim.ui.select = original_input, original_select
vim.system, vim.fn.executable = actual_system, actual_executable
vim.fn.delete(temporary, "rf")
print("PASS: queue handoffs, stale heads, conflict task ownership, duplicate keys, reports, and failure recovery")
