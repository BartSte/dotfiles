local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:append(root)
vim.env.TMUX_PANE = "%1"
local separator = string.char(31)
local function pane(session, path, command, window_name)
    return table.concat({ session, "2", "0", path, "Codex", command, path, window_name or "codex" }, separator)
end
local actual_system, actual_executable = vim.system, vim.fn.executable
vim.fn.executable = function() return 1 end
local calls, searches, sent, config_file = {}, 0
local payload = "Use $pr-attention.\nLiteral `code`, $(commands), and quotes: 'hello'."
local directory = "/tmp/project with spaces/pr-42"
vim.system = function(argv, _, callback)
    calls[#calls + 1] = argv
    local result = { code = 0, stdout = "", stderr = "" }
    if argv[1] == "tmux" and argv[2] == "list-panes" then
        searches = searches + 1
        assert(argv[3] == "-a")
        local available = { pane("unrelated", "/tmp/another-project", "codex") }
        if searches >= 2 then available[#available + 1] = pane("project--pr-42", directory, "codex") end
        result.stdout = table.concat(available, "\n")
    elseif argv[1] == "key2pane" then
        assert(argv[3] == "project--pr-42", "Handoffs must target the selected worktree's session")
        assert(argv[#argv] == payload, "The complete prompt must remain one literal argument")
        assert(vim.tbl_contains(argv, "--noreset"), "Pasting must not interrupt Codex")
        local index = assert(vim.fn.index(argv, "--config")) + 1
        config_file = argv[index + 1]
        local config = vim.json.decode(table.concat(vim.fn.readfile(config_file), "\n"))
        assert(#config.actions == 1 and config.actions[1].regex == "^codex$" and config.actions[1].paste == "{0}",
            "A pane that exits to a shell must not receive a shell action")
        assert(config.actions[1].keys == nil, "The prompt must not include an automatic Enter action")
        sent = true
    end
    callback(result)
end
require("helpers.codex").send(payload, { directory = directory, focus = true, wait_ms = 1000 })
assert(vim.wait(2000, function() return #calls >= 5 end))
assert(sent and searches == 2, "The handoff waits for Codex to start")
assert(calls[#calls - 1][2] == "select-window" and calls[#calls - 1][4] == "project--pr-42:2")
assert(calls[#calls][2] == "select-pane" and calls[#calls][4] == "project--pr-42:2.0")
assert(vim.fn.filereadable(config_file) == 0, "The temporary paste configuration must be cleaned up")

-- Existing mappings retain their current-session discovery behavior.
local current_session_sent = false
vim.system = function(argv, _, callback)
    local result = { code = 0, stdout = "", stderr = "" }
    if argv[2] == "list-panes" then
        assert(argv[3] == "-s" and argv[5] == "%1")
        result.stdout = pane("current", directory, "codex")
    elseif argv[1] == "key2pane" then
        assert(argv[3] == "current")
        current_session_sent = true
    end
    callback(result)
end
require("helpers.codex").send("existing selection")
assert(vim.wait(1000, function() return current_session_sent end))
vim.system, vim.fn.executable = actual_system, actual_executable
print("PASS: worktree routing, Codex startup, literal prompt delivery, focus, cleanup, and existing mappings")
