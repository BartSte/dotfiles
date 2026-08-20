local M = {}

local FIELD_SEPARATOR = string.char(31)
local PANE_FORMAT = table.concat({
    "#{session_name}",
    "#{window_index}",
    "#{pane_index}",
    "#{pane_current_path}",
    "#{pane_title}",
    "#{pane_current_command}",
}, FIELD_SEPARATOR)

---@class CodexPane
---@field session string
---@field window string
---@field index string
---@field path string
---@field title string
---@field target string

local function notify(message, level)
    vim.notify(message, level, { title = "CodexSend" })
end

local function process_error(prefix, result)
    local detail = vim.trim(result.stderr or "")
    if detail == "" then
        detail = vim.trim(result.stdout or "")
    end
    if detail == "" then
        detail = "exit code " .. result.code
    end
    return prefix .. ": " .. detail
end

local function run(argv, on_exit)
    local ok, process = pcall(vim.system, argv, { text = true }, function(result)
        vim.schedule(function()
            on_exit(result)
        end)
    end)
    if not ok then
        notify("Could not start " .. argv[1] .. ": " .. tostring(process), vim.log.levels.ERROR)
        return false
    end
    return true
end

local function parse_panes(stdout)
    local panes = {}
    for _, line in ipairs(vim.split(stdout, "\n", { plain = true, trimempty = true })) do
        local fields = vim.split(line, FIELD_SEPARATOR, { plain = true })
        if #fields == 6 and fields[6] == "codex" then
            local pane = {
                session = fields[1],
                window = fields[2],
                index = fields[3],
                path = fields[4],
                title = fields[5],
                target = string.format("%s:%s.%s", fields[1], fields[2], fields[3]),
            }
            table.insert(panes, pane)
        end
    end
    return panes
end

local function send_to_pane(payload, pane)
    local argv = {
        "key2pane",
        "--session",
        pane.session,
        "--window",
        pane.window,
        "--index",
        pane.index,
        payload,
    }
    run(argv, function(result)
        if result.code ~= 0 then
            notify(process_error("key2pane failed", result), vim.log.levels.ERROR)
        end
    end)
end

local function select_pane(payload, panes)
    if #panes == 0 then
        notify("No Codex pane exists in the current tmux session.", vim.log.levels.WARN)
        return
    end

    if #panes == 1 then
        send_to_pane(payload, panes[1])
        return
    end

    vim.ui.select(panes, {
        prompt = "Select a Codex pane:",
        format_item = function(pane)
            local title = pane.title ~= "" and pane.title or "(no title)"
            local path = pane.path ~= "" and pane.path or "(no directory)"
            return string.format("%s  %s  %s", pane.target, path, title)
        end,
    }, function(pane)
        if pane == nil then
            notify("Codex pane selection canceled.", vim.log.levels.INFO)
            return
        end
        send_to_pane(payload, pane)
    end)
end

---Send text to a Codex pane in the current tmux session.
---@param payload string The text to send.
M.send = function(payload)
    if vim.fn.executable("tmux") ~= 1 then
        notify("The tmux executable is not available.", vim.log.levels.ERROR)
        return
    end
    if vim.fn.executable("key2pane") ~= 1 then
        notify("The key2pane executable is not available.", vim.log.levels.ERROR)
        return
    end

    local current_pane = vim.env.TMUX_PANE
    if current_pane == nil or current_pane == "" then
        notify("Neovim is not running in a tmux pane.", vim.log.levels.ERROR)
        return
    end

    local argv = {
        "tmux",
        "list-panes",
        "-s",
        "-t",
        current_pane,
        "-F",
        PANE_FORMAT,
    }
    run(argv, function(result)
        if result.code ~= 0 then
            notify(process_error("tmux pane search failed", result), vim.log.levels.ERROR)
            return
        end
        select_pane(payload, parse_panes(result.stdout or ""))
    end)
end

---Format complete lines as a Markdown fenced block.
---@param lines string[] The lines to format.
---@param filetype string The Neovim filetype for the fence label.
---@return string fenced_text The formatted text.
M.fenced = function(lines, filetype)
    return string.format("```%s\n%s\n```", filetype, table.concat(lines, "\n"))
end

---Send the current buffer path.
M.send_path = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        notify("The current buffer does not have a file name.", vim.log.levels.ERROR)
        return
    end
    M.send(vim.fs.normalize(vim.fn.fnamemodify(name, ":p")))
end

---Send complete lines from the current buffer.
---@param first_line integer The first one-based line number.
---@param last_line integer The last one-based line number.
M.send_lines = function(first_line, last_line)
    local lines = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, false)
    M.send(M.fenced(lines, vim.bo.filetype))
end

---Send the exact active visual selection.
M.send_visual = function()
    local lines = vim.fn.getregion(
        vim.fn.getpos("v"),
        vim.fn.getpos("."),
        { type = vim.fn.mode() }
    )
    M.send(M.fenced(lines, vim.bo.filetype))
end

return M
