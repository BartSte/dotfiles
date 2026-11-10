local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
local temporary = vim.fn.tempname()
local repository = temporary .. "/repository"
vim.fn.mkdir(repository, "p")
vim.env.XDG_STATE_HOME = temporary .. "/state"
local actual_system = vim.system
local function git(...)
    local argv = { "git", "-C", repository }
    vim.list_extend(argv, { ... })
    local result = actual_system(argv, { text = true }):wait()
    assert(result.code == 0, result.stderr)
    return vim.trim(result.stdout)
end
git("init", "-b", "main")
git("config", "user.name", "Fixture")
git("config", "user.email", "fixture@example.invalid")
git("config", "commit.gpgsign", "false")
vim.fn.writefile({ "original" }, repository .. "/policy.txt")
git("add", "policy.txt")
git("commit", "-m", "Initial")
git("checkout", "-b", "feature")
vim.fn.writefile({ "PR policy" }, repository .. "/policy.txt")
git("commit", "-am", "PR policy")
local head = git("rev-parse", "HEAD")
git("checkout", "main")
vim.fn.writefile({ "Base policy" }, repository .. "/policy.txt")
git("commit", "-am", "Base policy")
git("checkout", "feature")
local pr = { url = "https://github.com/example/project/pull/42", number = 42, title = "Policy",
    repository = { nameWithOwner = "example/project" }, author = { login = "bart" },
    headRefOid = head, inbox_categories = { "authored" }, mergeable = "CONFLICTING", mergeStateStatus = "DIRTY" }
package.loaded["helpers.pr_inbox"] = { collect = function(callback)
    callback({ host = "github.com", login = "bart", updated_at = os.time(), prs = { pr }, coverage = {} })
end }
package.loaded["octo.config"] = { values = { gh_cmd = "gh" } }
local complete, output_path, decision_prompt
vim.system = function(argv, options, callback)
    if argv[1] == "git" then return actual_system(argv, options, callback) end
    local result = { code = 0, stdout = "", stderr = "" }
    if argv[1] == "gh" then
        result.stdout = vim.json.encode({ author = pr.author, state = "OPEN", headRefOid = head,
            headRefName = "feature", baseRefName = "main", mergeable = "CONFLICTING" })
    elseif argv[1] == "tsp-pr" then result.stdout = repository .. "\n"
    elseif argv[1] == "codex" then
        output_path = argv[vim.fn.index(argv, "--output-last-message") + 2]
        decision_prompt, complete = argv[#argv], callback
        return {}
    else error("Unexpected command: " .. argv[1]) end
    callback(result)
    return {}
end
local executable = vim.fn.executable
vim.fn.executable = function() return 1 end
local queue = require("helpers.pr_attention")
queue.open()
local board = vim.api.nvim_get_current_buf()
local function select_pr()
    vim.api.nvim_set_current_buf(board)
    for line, text in ipairs(vim.api.nvim_buf_get_lines(board, 0, -1, false)) do
        if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); return end
    end
    error("PR missing")
end
local function action(key)
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(0, "n")) do
        if mapping.lhs == key then return mapping.callback() end
    end
    error("Mapping missing: " .. key)
end
local function state()
    return vim.json.decode(table.concat(vim.fn.readfile(output_path:gsub("%.output$", "") .. ".json"), "\n"))
end
select_pr()
action("m")
assert(vim.wait(1000, function() return complete ~= nil end))
local merge = actual_system({ "git", "-C", repository, "merge", "--no-commit", "--no-ff", "main" }, { text = true }):wait()
assert(merge.code == 1, "Fixture must produce a real merge conflict")
vim.fn.writefile({ "Choose the policy version." }, output_path)
complete({ code = 0, stdout = "", stderr = "" })
assert(vim.wait(1000, function() return state().state == "Needs a decision" end))
assert(state().unresolved[1] == "policy.txt")
assert(vim.api.nvim_get_current_buf() == board)
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", { buffer = board })
local details = vim.api.nvim_buf_get_extmarks(board, vim.api.nvim_create_namespace("PrAttentionDetails"),
    0, -1, { details = true })
assert(#details == 1 and vim.inspect(details):find("Needs a decision", 1, true),
    "Unresolved decisions must stay visible even when their PR is not selected")
select_pr()
action("M")
local input = vim.ui.input
vim.ui.input = function(_, callback) callback("Use version 5.") end
complete = nil
action("m")
assert(vim.wait(1000, function() return complete ~= nil end))
assert(decision_prompt:find("Use version 5.", 1, true))
assert(git("rev-parse", "HEAD") == head, "Resume must preserve the original HEAD")
vim.fn.writefile({ "Resolved version 5" }, repository .. "/policy.txt")
git("add", "policy.txt")
vim.fn.writefile({ "Resolved. Relevant tests passed." }, output_path)
complete({ code = 0, stdout = "", stderr = "" })
assert(vim.wait(1000, function() return state().state == "Ready for review" end))
assert(git("rev-parse", "HEAD") == head, "Resolution must not commit automatically")
select_pr()
action("M")
local select = vim.ui.select
vim.ui.select = function(choices, _, callback) callback(choices[2], 2) end
vim.ui.input = function(_, callback) callback("chore: resolve policy merge") end
action("c")
assert(vim.wait(2000, function() return state().state == "Committed locally" end))
assert(git("rev-list", "--parents", "-n", "1", "HEAD"):match("^%w+ %w+ %w+$"), "Review action must create a merge commit")
assert(state().commit == git("rev-parse", "HEAD"))
vim.system, vim.fn.executable, vim.ui.input, vim.ui.select = actual_system, executable, input, select
vim.fn.delete(temporary, "rf")
print("PASS: real Git conflict detection, decision resume, local status, and explicit merge commit")
