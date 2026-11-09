local M = {}
local memory = require("helpers.pr_attention_state")
local board, snapshot, rows, checkpoints = nil, nil, {}, {}
local show_all, loading, generation = false, false, 0
local last_error
local context_directory
local opening = false
local groups = { "Requested reviews", "Team requests", "Review follow-ups", "Your PRs" }
local namespace = vim.api.nvim_create_namespace("PrAttention")
local status_highlights = { NEW = "DiagnosticInfo", UPDATED = "DiagnosticWarn", ACTIVITY = "DiagnosticWarn",
    ACTION = "DiagnosticError", CHECKED = "Comment", SNOOZED = "Comment", WAITING = "Comment",
    REVIEWED = "Special", ["MERGE?"] = "DiagnosticHint", DRAFT = "Comment" }

local function theme()
    local function color(group)
        return vim.api.nvim_get_hl(0, { name = group, link = false })
    end
    local normal = color("Normal")
    local function tint(foreground, background)
        local result = 0
        for _, unit in ipairs({ 65536, 256, 1 }) do
            local accent, base = math.floor(foreground / unit) % 256, math.floor(background / unit) % 256
            result = result + math.floor(accent * 0.12 + base * 0.88) * unit
        end
        return result
    end
    for name, source in pairs({ Title = "Title", Muted = "Comment", Rule = "WinSeparator",
        Repo = "Directory", Added = "DiagnosticHint", Removed = "DiagnosticError", Key = "Special" }) do
        vim.api.nvim_set_hl(0, "PrAttention" .. name,
            { fg = color(source).fg or normal.fg, bold = name == "Title", italic = false })
    end
    for status, source in pairs(status_highlights) do
        local foreground = color(source).fg or normal.fg or 0xaaaaaa
        vim.api.nvim_set_hl(0, "PrAttentionStatus" .. status:gsub("%W", ""),
            { fg = foreground, bg = tint(foreground, normal.bg or 0x181818), bold = true, italic = false })
    end
end

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "PR attention" })
end

local function selected()
    if loading then return nil end
    return rows[vim.api.nvim_win_get_cursor(0)[1]]
end

local function pad(text, width, align_right)
    local spaces = string.rep(" ", math.max(0, width - vim.fn.strdisplaywidth(text)))
    return align_right and spaces .. text or text .. spaces
end

local function scratch(title, lines, filetype)
    vim.cmd("botright new")
    local buffer = vim.api.nvim_get_current_buf()
    vim.bo[buffer].buftype = "nofile"
    vim.bo[buffer].bufhidden = "wipe"
    vim.bo[buffer].swapfile = false
    vim.bo[buffer].filetype = filetype or "markdown"
    vim.api.nvim_buf_set_name(buffer, "pr-attention://" .. title .. "/" .. buffer)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    vim.bo[buffer].modifiable = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buffer, silent = true })
    return buffer
end

local function render()
    if not board or not vim.api.nvim_buf_is_valid(board) then return end
    theme()
    local lines, highlights = {}, {}
    rows = {}
    local function add(text, group, pr)
        lines[#lines + 1] = text
        rows[#lines] = pr
        if group then highlights[#highlights + 1] = { line = #lines - 1, group = group } end
    end
    local function segments(parts, pr)
        local line = ""
        for _, part in ipairs(parts) do
            if part[2] then
                highlights[#highlights + 1] = { line = #lines, col = #line,
                    end_col = #line + #part[1], group = part[2] }
            end
            line = line .. part[1]
        end
        add(line, nil, pr)
    end
    local function controls(entries)
        local parts = { { "  " } }
        for _, entry in ipairs(entries) do
            parts[#parts + 1] = { entry[1], "PrAttentionKey" }
            parts[#parts + 1] = { " " .. entry[2] .. "    ", "PrAttentionMuted" }
        end
        segments(parts)
    end
    segments({ { "  PR attention", "PrAttentionTitle" },
        { "    " .. os.date("%A, %d %B"), "PrAttentionMuted" } })
    if snapshot then
        local owners = {}
        for _, pr in ipairs(snapshot.prs) do
            local owner = pr.repository.nameWithOwner:match("^([^/]+)/")
            if owner then owners[owner] = true end
        end
        local common_owner = vim.tbl_count(owners) == 1 and next(owners) or nil
        add("  " .. snapshot.login .. " @ " .. snapshot.host .. (common_owner and "  ·  " .. common_owner or "")
            .. "  ·  Snapshot: " .. os.date("%H:%M", snapshot.updated_at)
            .. (loading and "  ·  refreshing..." or ""), "PrAttentionMuted")
        for source, coverage in pairs(snapshot.coverage or {}) do
            if not coverage.complete then add("  COVERAGE GAP: " .. source .. " search exceeds 1,000 results", "DiagnosticWarn") end
        end
        if last_error then add("  REFRESH FAILED: " .. last_error, "DiagnosticError") end
        local buckets, checked, waiting, active = { {}, {}, {}, {} }, 0, 0, 0
        local pr_width, added_width, removed_width = 0, 0, 0
        for _, pr in ipairs(snapshot.prs) do
            local group, status, reason, quiet = memory.describe(pr, snapshot.login, checkpoints[pr.url])
            if status == "CHECKED" or status == "SNOOZED" then checked = checked + 1
            elseif quiet then waiting = waiting + 1
            else active = active + 1 end
            if show_all or not quiet then
                local repository = common_owner and pr.repository.nameWithOwner:match("^[^/]+/(.+)$")
                    or pr.repository.nameWithOwner
                local label = repository .. "#" .. pr.number
                local added, removed = "+" .. (pr.additions or "?"), "−" .. (pr.deletions or "?")
                pr_width = math.max(pr_width, vim.fn.strdisplaywidth(label))
                added_width = math.max(added_width, vim.fn.strdisplaywidth(added))
                removed_width = math.max(removed_width, vim.fn.strdisplaywidth(removed))
                buckets[group][#buckets[group] + 1] = {
                    pr = pr, status = status, reason = reason, label = label, added = added, removed = removed,
                }
            end
        end
        add("")
        segments({ { "  " }, { active .. " to inspect", "PrAttentionTitle" },
            { "    ·    " .. checked .. " checked/deferred    ·    " .. waiting .. " awaiting others", "PrAttentionMuted" } })
        add("")
        controls({ { "o", "open in Octo" }, { "D", "changes" }, { "w", "worktree" }, { "c", "open in Codex" }, { "b", "browser" } })
        controls({ { "d", "checked" }, { "s", "tomorrow" }, { "u", "undo" }, { "r", "refresh" },
            { "a", show_all and "hide checked" or "show all" }, { "C", "copy brief" }, { "q", "close" } })
        if active == 0 then add("  No unhandled items in this snapshot. Refresh to look for new activity.", "PrAttentionMuted") end
        local width = vim.o.columns
        for _, window in ipairs(vim.fn.win_findbuf(board)) do
            width = math.min(width, vim.api.nvim_win_get_width(window))
        end
        for index, bucket in ipairs(buckets) do
            table.sort(bucket, function(left, right) return left.pr.url < right.pr.url end)
            if #bucket > 0 or show_all then
                add("")
                segments({ { "  " .. groups[index], "PrAttentionTitle" }, { "   " .. #bucket, "PrAttentionMuted" } })
                add("  " .. string.rep("─", math.max(1, math.min(width - 4, 120))), "PrAttentionRule")
            end
            for _, item in ipairs(bucket) do
                local pr = item.pr
                local prefix = { { "  " }, { " " .. pad(item.status, 8) .. " ", "PrAttentionStatus" .. item.status:gsub("%W", "") },
                    { "  " }, { pad(item.label, pr_width), "PrAttentionRepo" }, { "   " },
                    { pad(item.added, added_width, true), "PrAttentionAdded" }, { " " },
                    { pad(item.removed, removed_width, true), "PrAttentionRemoved" } }
                local title = (pr.title or ""):gsub("%c", " ")
                local title_column = 2 + 10 + 2 + pr_width + 3 + added_width + 1 + removed_width + 3
                if width - title_column < 35 then
                    segments(prefix, pr)
                    segments({ { string.rep(" ", 14) }, { title }, { pr.isDraft and "  draft" or "", "PrAttentionMuted" } }, pr)
                else
                    vim.list_extend(prefix, { { "   " }, { title }, { pr.isDraft and "  draft" or "", "PrAttentionMuted" } })
                    segments(prefix, pr)
                end
                add(string.rep(" ", 14) .. item.reason, "PrAttentionMuted", pr)
            end
        end
        add("")
    else
        add("  " .. (last_error or "Loading GitHub..."), "PrAttentionMuted")
        controls({ { "r", "refresh" }, { "q", "close" } })
    end
    vim.bo[board].modifiable = true
    vim.api.nvim_buf_set_lines(board, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(board, namespace, 0, -1)
    for _, highlight in ipairs(highlights) do
        local options = { hl_group = highlight.group }
        if highlight.end_col then
            options.end_col = highlight.end_col
        else
            options.end_row, options.hl_eol = highlight.line + 1, true
        end
        vim.api.nvim_buf_set_extmark(board, namespace, highlight.line, highlight.col or 0, options)
    end
    vim.bo[board].modifiable = false
end

local function checkpoint(snooze)
    local pr = selected()
    if not pr or not snapshot then return end
    local until_date
    if snooze then
        local tomorrow = os.date("*t")
        tomorrow.day, tomorrow.hour, tomorrow.min, tomorrow.sec = tomorrow.day + 1, 0, 0, 0
        until_date = os.time(tomorrow)
    end
    local record, err = memory.write(snapshot.host, snapshot.login, pr, until_date)
    if not record then notify(err, vim.log.levels.ERROR); return end
    checkpoints[pr.url] = record
    render()
    notify(snooze and "Deferred locally until tomorrow. New activity will resurface this PR."
        or "Checked this snapshot locally. No GitHub review was posted.")
end

local function command(arguments, callback, on_error)
    local config = require("octo.config").values
    local argv = { config.gh_cmd or "gh" }
    vim.list_extend(argv, arguments)
    vim.system(argv, { cwd = context_directory, env = config.gh_env, text = true, timeout = 30000 },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                notify(vim.trim(result.stderr or "GitHub request failed"), vim.log.levels.ERROR)
                if on_error then on_error() end
            else callback(result.stdout) end
        end))
end

local function changes()
    local pr = selected()
    if not pr then return end
    local baseline, source = memory.baseline(pr, snapshot.login, checkpoints[pr.url])
    if not baseline then notify("No review baseline. Open the complete PR in Octo."); return end
    if baseline == pr.headRefOid then
        notify("The head matches your " .. source .. ". Inspect conversations and requests in Octo.")
        return
    end
    local endpoint = "repos/" .. pr.repository.nameWithOwner .. "/compare/" .. baseline .. "..." .. pr.headRefOid
    command({ "api", "--hostname", snapshot.host, endpoint }, function(output)
        local comparison = vim.json.decode(output)
        local lines = { "# Changes since " .. source, "", baseline .. " -> " .. pr.headRefOid,
            "Comparison: " .. comparison.status, "" }
        if comparison.status ~= "ahead" then
            lines[#lines + 1] = "History diverged or moved backwards. This comparison cannot establish the full delta."
            lines[#lines + 1] = "Inspect the complete PR in Octo and compare both snapshots in the worktree."
        end
        for _, file in ipairs(comparison.files or {}) do
            vim.list_extend(lines, { "", "diff --git a/" .. (file.previous_filename or file.filename) .. " b/" .. file.filename,
                "--- a/" .. (file.previous_filename or file.filename), "+++ b/" .. file.filename })
            if type(file.patch) == "string" then vim.list_extend(lines, vim.split(file.patch, "\n", { plain = true }))
            else lines[#lines + 1] = "[Patch unavailable: inspect this file in Octo or the worktree.]" end
        end
        if #(comparison.files or {}) >= 300 then
            lines[#lines + 1] = "[GitHub returns at most 300 files. Use the worktree for a complete comparison.]"
        end
        scratch("changes-since-review", lines, "diff")
    end)
end

local function open_worktree(pr, on_open)
    if not pr then return end
    if not vim.env.TMUX or vim.env.TMUX == "" then notify("Open Neovim inside tmux to use the worktree action."); return end
    if snapshot.host ~= "github.com" then notify("tsp-pr currently supports github.com repositories only."); return end
    if opening then notify("A PR worktree is already opening."); return end
    opening = true
    local directory = context_directory
    -- Resolve fresh refs; tsp-pr keeps existing worktrees and their local changes.
    command({ "pr", "view", pr.url, "--json", "baseRefName,headRefName,headRefOid" }, function(output)
        local refs = vim.json.decode(output)
        if refs.headRefOid ~= pr.headRefOid then
            opening = false
            notify("The head changed. Refresh and inspect the new snapshot before opening this worktree."); return
        end
        vim.system({ "tsp-pr", "--prepare-only", "--expected-head", pr.headRefOid, pr.repository.nameWithOwner,
            tostring(pr.number), refs.baseRefName, refs.headRefName },
            { cwd = directory, text = true }, vim.schedule_wrap(function(result)
                if result.code ~= 0 then
                    opening = false
                    notify(vim.trim(result.stderr), vim.log.levels.ERROR)
                    return
                end
                local path = result.stdout:gsub("\n$", "")
                if path == "" or vim.fn.isdirectory(path) ~= 1 then
                    opening = false
                    notify("tsp-pr did not return a valid worktree path.", vim.log.levels.ERROR)
                    return
                end
                vim.system({ "tsp", path }, { cwd = directory, text = true }, vim.schedule_wrap(function(session_result)
                    opening = false
                    if session_result.code ~= 0 then
                        notify(vim.trim(session_result.stderr), vim.log.levels.ERROR)
                    elseif on_open then
                        on_open(path)
                    end
                end))
            end))
    end, function() opening = false end)
end

local function brief(pr)
    local baseline, source = memory.baseline(pr, snapshot.login, checkpoints[pr.url])
    local own = pr.author and pr.author ~= vim.NIL and pr.author.login == snapshot.login
    local prompt = {
        "Use $pr-attention to prepare this selected PR only: " .. pr.url,
        "Expected head: " .. pr.headRefOid,
        baseline and ("Previous assessment: " .. baseline .. " (" .. source .. ").") or "No previous assessment is known.",
        own and "Assess feedback critically with $pr-respond." or "Review the current PR with $pr-post.",
        "Refresh the head and feedback. Inspect the complete relevant context, including changes since the previous assessment.",
        "Prepare exact proposals. Do not edit code or write to GitHub before approval.",
    }
    return prompt
end

local function copy_brief()
    local pr = selected()
    if not pr then return end
    local prompt = brief(pr)
    vim.fn.setreg("+", table.concat(prompt, "\n"))
    scratch("codex-brief", vim.list_extend({ "# Codex brief", "", "Copied to the clipboard. Paste into the PR worktree's Codex window.", "" }, prompt))
end

local function send_brief()
    local pr = selected()
    if not pr then return end
    if vim.fn.executable("key2pane") ~= 1 then
        notify("key2pane is required to insert the Codex brief.", vim.log.levels.ERROR)
        return
    end
    local payload = table.concat(brief(pr), "\n")
    open_worktree(pr, function(path)
        require("helpers.codex").send(payload, { directory = path, focus = true, wait_ms = 10000 })
    end)
end

function M.refresh()
    if loading then return end
    loading = true
    last_error = nil
    generation = generation + 1
    local request = generation
    local request_directory = vim.fn.getcwd()
    render()
    require("helpers.pr_inbox").collect(function(result)
        if request ~= generation then return end
        context_directory = request_directory
        loading, snapshot, checkpoints = false, result, {}
        for _, pr in ipairs(result.prs) do
            local record, err = memory.read(result.host, result.login, pr.url)
            checkpoints[pr.url] = record
            if err then notify(err, vim.log.levels.WARN) end
        end
        render()
    end, function(message)
        if request ~= generation then return end
        loading = false
        last_error = message
        render()
        notify("Refresh failed. The previous snapshot remains visible: " .. message, vim.log.levels.ERROR)
    end)
end

function M.open()
    if not board or not vim.api.nvim_buf_is_valid(board) then
        board = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(board, "pr-attention://daily")
        vim.bo[board].bufhidden = "hide"
        vim.bo[board].swapfile = false
        vim.bo[board].filetype = "pr_attention"
        local actions = {
            o = function()
                local pr = selected()
                if pr then require("octo.utils").get_pull_request(pr.number, pr.repository.nameWithOwner) end
            end,
            d = function() checkpoint(false) end,
            s = function() checkpoint(true) end,
            u = function()
                local pr = selected()
                if not pr then return end
                local ok, err = memory.clear(snapshot.host, snapshot.login, pr.url)
                if not ok then notify(err, vim.log.levels.ERROR); return end
                checkpoints[pr.url] = nil
                render()
            end,
            r = M.refresh,
            a = function() show_all = not show_all; render() end,
            D = changes, w = function() open_worktree(selected()) end, c = send_brief, C = copy_brief,
            b = function() local pr = selected(); if pr then vim.ui.open(pr.url) end end,
            q = function() vim.cmd("enew") end,
        }
        for key, action in pairs(actions) do
            vim.keymap.set("n", key, action, { buffer = board, silent = true, desc = "PR attention: " .. key })
        end
    end
    vim.api.nvim_set_current_buf(board)
    render()
    M.refresh()
end

function M.setup()
    vim.api.nvim_create_user_command("PrAttention", M.open, { desc = "Daily PR queue with local review checkpoints" })
end

return M
