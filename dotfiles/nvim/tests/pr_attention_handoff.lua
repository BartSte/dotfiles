local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
local temporary = vim.fn.tempname()
local directory = temporary .. "/worktree with spaces"
vim.fn.mkdir(directory, "p")
vim.env.XDG_STATE_HOME = temporary
local socket = "pr-attention-test-" .. vim.fn.getpid()
local actual_system, actual_executable = vim.system, vim.fn.executable
local function isolated_tmux(arguments)
    local argv = { "tmux", "-L", socket, "-f", "/dev/null" }
    vim.list_extend(argv, arguments)
    return argv
end
local function run_tmux(...)
    local result = actual_system(isolated_tmux({ ... }), { text = true }):wait()
    assert(result.code == 0, result.stderr)
    return vim.trim(result.stdout)
end
local ok, err = xpcall(function()
    local source = run_tmux("new-session", "-d", "-P", "-F", "#{pane_id}", "-s", "queue", "-c", directory, "cat")
    vim.env.TMUX, vim.env.TMUX_PANE = "isolated-test-server", source
    -- An interactive stand-in records its literal argument and stays alive in tmux.
    local fixture = temporary .. "/fixture.lua"
    vim.fn.writefile({
        'vim.fn.writefile({ vim.json.encode({ directory = vim.fn.getcwd(), prompt = arg[2] }) }, arg[1])',
        'vim.wait(60000, function() return false end)',
    }, fixture)
    local pr = { url = "https://github.com/example/project/pull/42", number = 42, title = "Example",
        repository = { nameWithOwner = "example/project" }, author = { login = "colleague" },
        headRefOid = string.rep("b", 40), inbox_categories = { "review" } }
    package.loaded["helpers.pr_inbox"] = { collect = function(callback)
        callback({ host = "github.com", login = "bart", updated_at = os.time(), prs = { pr }, coverage = {} })
    end }
    package.loaded["octo.config"] = { values = { gh_cmd = "gh" } }
    local calls, sessions, notices = {}, {}, {}
    local fail_preparation, stale, closed, fail_launch, missing_codex = false, false, false, false, false
    local mergeable, fresh_author = "CONFLICTING", nil
    vim.notify = function(message) notices[#notices + 1] = message end
    vim.fn.executable = function(name) return name == "codex" and missing_codex and 0 or 1 end
    vim.system = function(argv, options, callback)
        calls[#calls + 1] = argv
        local result = { code = 0, stderr = "", stdout = "" }
        if argv[1] == "tmux" then
            local command = vim.list_slice(argv, 2)
            if command[1] == "new-window" then
                if fail_launch then
                    callback({ code = 1, stdout = "", stderr = "Synthetic tmux launch failure" })
                    return
                end
                local index = assert(vim.fn.index(command, "codex") + 1)
                assert(index > 0 and command[index + 1] == "--cd" and command[index + 2] == directory)
                local prompt = command[index + 3]
                assert(#command == index + 3, "Codex must receive one literal prompt argument")
                local output = temporary .. "/session-" .. (#sessions + 1) .. ".json"
                sessions[#sessions + 1] = { prompt = prompt, output = output }
                command = vim.list_slice(command, 1, index - 1)
                vim.list_extend(command, { "nvim", "--headless", "-u", "NONE", "-l", fixture, output, prompt })
            end
            return actual_system(isolated_tmux(command), options, callback)
        elseif argv[1] == "gh" then
            assert(argv[2] == "pr" and argv[3] == "view", "The queue must only read GitHub metadata")
            result.stdout = vim.json.encode({ headRefOid = stale and string.rep("c", 40) or pr.headRefOid,
                baseRefName = "main", headRefName = "feature/review", author = { login = fresh_author or pr.author.login },
                state = closed and "CLOSED" or "OPEN", mergeable = mergeable })
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
    local tabs = #vim.api.nvim_list_tabpages()
    local function select_pr()
        for line, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
            if text:find("project#42", 1, true) then vim.api.nvim_win_set_cursor(0, { line, 0 }); return end
        end
        error("PR missing")
    end
    local function mapping(key)
        for _, entry in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
            if entry.lhs == key then return entry.callback end
        end
    end
    local function action(key) return assert(mapping(key), "Missing mapping: " .. key)() end
    local function wait_for_session(count)
        assert(vim.wait(3000, function()
            return #sessions == count and vim.fn.filereadable(sessions[count].output) == 1
                and run_tmux("display-message", "-p", "-t", "queue:", "#{@pr_attention_url}") == pr.url
        end), "Codex window did not start and become active")
        vim.wait(50)
        local captured = vim.json.decode(table.concat(vim.fn.readfile(sessions[count].output), "\n"))
        assert(captured.directory == directory and captured.prompt == sessions[count].prompt,
            "tmux must preserve the worktree and prompt literally, including $pr-post")
        assert(vim.api.nvim_get_current_buf() == buffer and #vim.api.nvim_list_tabpages() == tabs,
            "Codex must leave Neovim on the queue without opening terminal buffers or tabs")
    end
    local function close_codex()
        run_tmux("kill-window", "-t", "queue:codex-example-project-42")
    end
    for _, key in ipairs({ "c", "C", "m", "M" }) do assert(not mapping(key), "Old Codex action remains: " .. key) end
    select_pr()
    vim.env.TMUX = nil
    action("R")
    assert(#calls == 0 and notices[#notices]:find("inside tmux", 1, true))
    vim.env.TMUX = "isolated-test-server"
    action("R")
    action("R")
    wait_for_session(1)
    local prompt = sessions[1].prompt
    for _, text in ipairs({ pr.url, pr.headRefOid, "$pr-post", "/review", "every pending comment", "Critically review my pending comments",
        "Do not edit or delete them without my approval", "before approval", "do not submit that review", "_Codex (AI) for Bart._" }) do
        assert(prompt:find(text, 1, true), "Missing review requirement: " .. text)
    end
    local first_calls = #calls
    run_tmux("select-window", "-t", source)
    action("R")
    assert(vim.wait(1000, function() return #calls == first_calls + 3 end))
    vim.wait(50)
    assert(#sessions == 1 and run_tmux("display-message", "-p", "-t", "queue:", "#{window_name}") == "codex-example-project-42",
        "Repeated actions must return to the existing Codex window")

    -- Session lookup must survive a fresh module instance, including a stale queue head.
    vim.api.nvim_buf_delete(buffer, { force = true })
    package.loaded["helpers.pr_attention"] = nil
    queue = require("helpers.pr_attention")
    queue.open()
    buffer = vim.api.nvim_get_current_buf()
    select_pr()
    first_calls, stale = #calls, true
    action("R")
    assert(vim.wait(1000, function() return #calls == first_calls + 3 end))
    vim.wait(50)
    assert(#sessions == 1, "An existing conversation must reopen without preparing or resetting its worktree")
    close_codex()

    calls, stale, fail_preparation = {}, false, true
    action("R")
    assert(vim.wait(1000, function() return notices[#notices] == "Synthetic worktree update failure" end))
    assert(#sessions == 1)
    calls, fail_preparation, stale = {}, false, true
    action("R")
    assert(vim.wait(1000, function() return #calls == 2 end))
    vim.wait(50)
    assert(#sessions == 1, "A stale head must stop before worktree preparation")
    calls, stale, closed = {}, false, true
    action("R")
    assert(vim.wait(1000, function() return #calls == 2 end))
    vim.wait(50)
    assert(#sessions == 1, "A closed PR must not start a review")
    calls, closed, missing_codex = {}, false, true
    action("R")
    assert(#calls == 0 and #sessions == 1)
    missing_codex, fail_launch = false, true
    action("R")
    assert(vim.wait(1000, function() return notices[#notices]:find("Synthetic tmux launch failure", 1, true) ~= nil end))
    fail_launch = false

    calls = {}
    action("F")
    assert(vim.wait(1000, function() return notices[#notices]:find("own PRs only", 1, true) ~= nil end))
    assert(#calls == 1, "A colleague's PR must not prepare a resolver worktree")
    pr.author.login, fresh_author = "bart", "colleague"
    calls = {}
    action("F")
    assert(vim.wait(1000, function() return #calls == 2 end))
    vim.wait(50)
    assert(#sessions == 1, "Fresh metadata must confirm ownership")
    calls, fresh_author, mergeable = {}, nil, "MERGEABLE"
    action("F")
    assert(vim.wait(1000, function() return #calls == 2 end))
    vim.wait(50)
    assert(#sessions == 1, "A PR without conflicts must not start a resolver")
    calls, mergeable = {}, "CONFLICTING"
    action("F")
    wait_for_session(2)
    prompt = sessions[2].prompt
    for _, text in ipairs({ pr.url, pr.headRefOid, "rebasing", "commit all intended", "no unfinished Git operation",
        "including forks", "ask me in this interactive session", "git status is clean", "Run the relevant tests",
        "Do not push", "explicit approval", "--force-with-lease=refs/heads/<source-branch>:<recorded-remote-SHA>",
        "only remaining Git operation" }) do
        assert(prompt:find(text, 1, true), "Missing conflict requirement: " .. text)
    end
    close_codex()
    calls = {}
    action("w")
    assert(vim.wait(1000, function() return #calls == 3 end))
    assert(calls[3][1] == "tsp" and #sessions == 2)
    print("PASS: real isolated tmux windows, literal prompts, window switching, restart reuse, unchanged Neovim UI, and failure recovery")
end, debug.traceback)
actual_system(isolated_tmux({ "kill-server" }), { text = true }):wait()
vim.system, vim.fn.executable = actual_system, actual_executable
vim.fn.delete(temporary, "rf")
assert(ok, err)
