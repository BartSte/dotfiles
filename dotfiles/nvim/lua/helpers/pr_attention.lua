local M = {}
local memory = require("helpers.pr_attention_state")
local board, snapshot, rows, checkpoints = nil, nil, {}, {}
local show_all, loading, generation = false, false, 0
local context_directory
local opening = false
local conflict_jobs = {}
local conflict_summary
local resolve_conflicts
local groups = { "Requested reviews", "Team requests", "Review follow-ups", "Your PRs" }
local namespace = vim.api.nvim_create_namespace("PrAttention")
local detail_namespace = vim.api.nvim_create_namespace("PrAttentionDetails")
local detail_rows = {}
local status_highlights = { NEW = "DiagnosticInfo", UPDATED = "DiagnosticWarn", ACTIVITY = "DiagnosticWarn",
    ACTION = "DiagnosticError", CHECKED = "Comment", SNOOZED = "Comment", WAITING = "Comment",
    REVIEWED = "Special", ["MERGE?"] = "DiagnosticHint", DRAFT = "Comment" }
local status_icons = { NEW = "", UPDATED = "", ACTIVITY = "", ACTION = "", CHECKED = "",
    SNOOZED = "󰒲", WAITING = "", REVIEWED = "", ["MERGE?"] = "", DRAFT = "" }

local function theme()
    local function color(group)
        return vim.api.nvim_get_hl(0, { name = group, link = false })
    end
    local normal = color("Normal")
    for name, source in pairs({ Title = "Title", Muted = "Comment", Rule = "WinSeparator",
        Repo = "Directory", Added = "DiagnosticHint", Removed = "DiagnosticError", Key = "Special" }) do
        vim.api.nvim_set_hl(0, "PrAttention" .. name,
            { fg = color(source).fg or normal.fg, bold = name == "Title", italic = false })
    end
    for status, source in pairs(status_highlights) do
        local foreground = color(source).fg or normal.fg or 0xaaaaaa
        vim.api.nvim_set_hl(0, "PrAttentionStatus" .. status:gsub("%W", ""),
            { fg = foreground, bold = false, italic = false })
    end
end

local function notify(message, level, options)
    vim.notify(message, level or vim.log.levels.INFO,
        vim.tbl_extend("force", { title = "PR attention" }, options or {}))
end

local function progress_notice(message, id)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    notify(message, nil, {
        id = id or "pr_attention_refresh",
        timeout = false,
        opts = function(notification)
            notification.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
    })
end

local function refresh_result(message, level)
    notify(message, level, { id = "pr_attention_refresh" })
end

local function feedback(message)
    notify(message, nil, { id = "pr_attention_action", timeout = 2000 })
end

local function label(pr)
    return pr.repository.nameWithOwner .. "#" .. pr.number
end

local function selected()
    if loading then
        feedback("The queue is still loading. Wait for the refresh to finish.")
        return nil
    end
    local pr = rows[vim.api.nvim_win_get_cursor(0)[1]]
    if not pr then feedback("No PR selected. Move the cursor to a PR row.") end
    return pr
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

local function show_details()
    if not board or not vim.api.nvim_buf_is_valid(board) then return end
    local focused = vim.api.nvim_get_current_buf() == board and rows[vim.api.nvim_win_get_cursor(0)[1]]
    vim.api.nvim_buf_clear_namespace(board, detail_namespace, 0, -1)
    for line, detail in pairs(detail_rows) do
        if detail.blocker or (focused and focused.url == detail.pr.url) then
            local lines = { detail.parts }
            if focused and focused.url == detail.pr.url then vim.list_extend(lines, detail.context) end
            vim.api.nvim_buf_set_extmark(board, detail_namespace, line - 1, 0, {
                virt_lines = lines,
            })
        end
    end
end

local function pr_context(pr, login, indent, width)
    local parts = { { indent, "PrAttentionMuted" } }
    local lines, used = {}, vim.fn.strdisplaywidth(indent)
    local function append(text, group)
        local size = vim.fn.strdisplaywidth(text)
        if #parts > 1 and used + 5 + size > width then
            lines[#lines + 1] = parts
            parts, used = { { indent, "PrAttentionMuted" } }, vim.fn.strdisplaywidth(indent)
        end
        if #parts > 1 then parts[#parts + 1] = { "  ·  ", "PrAttentionMuted" } end
        parts[#parts + 1] = { text, group or "PrAttentionMuted" }
        used = used + size + (#parts > 2 and 5 or 0)
    end
    if type(pr.author) == "table" and type(pr.author.login) == "string" then
        append(pr.author.login == login and "by you" or "@" .. pr.author.login)
    end
    if type(pr.baseRefName) == "string" then append(" " .. pr.baseRefName, "PrAttentionRepo") end
    local commits = (type(pr.commits) == "table" and pr.commits.nodes) or {}
    local commit = commits[1] and commits[1].commit
    local rollup = type(commit) == "table" and commit.statusCheckRollup
    local checks = type(rollup) == "table" and rollup.state
    local check_labels = { SUCCESS = { " CI passed", "DiagnosticHint" },
        FAILURE = { " CI failed", "DiagnosticError" }, ERROR = { " CI error", "DiagnosticError" },
        PENDING = { " CI pending", "DiagnosticWarn" }, EXPECTED = { " CI expected", "DiagnosticWarn" } }
    local check = check_labels[checks]
    if check then append(check[1], check[2]) else append("CI not reported") end
    local review_labels = { APPROVED = { " approved", "DiagnosticHint" },
        CHANGES_REQUESTED = { " changes requested", "DiagnosticWarn" }, REVIEW_REQUIRED = { " review required", "DiagnosticWarn" } }
    local review = review_labels[pr.reviewDecision]
    if review then append(review[1], review[2]) end
    lines[#lines + 1] = parts
    return lines
end

local function render()
    if not board or not vim.api.nvim_buf_is_valid(board) then return end
    theme()
    local width = vim.o.columns
    for _, window in ipairs(vim.fn.win_findbuf(board)) do
        local info = vim.fn.getwininfo(window)[1]
        width = math.min(width, vim.api.nvim_win_get_width(window) - (info and info.textoff or 0))
    end
    local margin = "  "
    local lines, highlights = {}, {}
    local previous = vim.api.nvim_get_current_buf() == board and rows[vim.api.nvim_win_get_cursor(0)[1]]
    rows = {}
    detail_rows = {}
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
        local parts, used = { { margin } }, #margin
        for _, entry in ipairs(entries) do
            local size = vim.fn.strdisplaywidth(entry[1] .. " " .. entry[2]) + 4
            if used + size > width - #margin and #parts > 1 then
                segments(parts)
                parts, used = { { margin } }, #margin
            end
            parts[#parts + 1] = { entry[1], "PrAttentionKey" }
            parts[#parts + 1] = { " " .. entry[2] .. "    ", "PrAttentionMuted" }
            used = used + size
        end
        segments(parts)
    end
    segments({ { margin .. "  PR attention", "PrAttentionTitle" },
        { "   /   " .. os.date("%a, %d %b"), "PrAttentionMuted" } })
    if snapshot then
        local owners = {}
        for _, pr in ipairs(snapshot.prs) do
            local owner = pr.repository.nameWithOwner:match("^([^/]+)/")
            if owner then owners[owner] = true end
        end
        local common_owner = vim.tbl_count(owners) == 1 and next(owners) or nil
        add(margin .. snapshot.login .. " @ " .. snapshot.host .. (common_owner and "  ·  " .. common_owner or "")
            .. "  ·  " .. os.date("%H:%M", snapshot.updated_at), "PrAttentionMuted")
        local buckets, checked, waiting, active = { {}, {}, {}, {} }, 0, 0, 0
        local pr_width, added_width, removed_width = 0, 0, 0
        for _, pr in ipairs(snapshot.prs) do
            local group, status, reason, quiet = memory.describe(pr, snapshot.login, checkpoints[pr.url])
            local local_status = conflict_summary and conflict_summary(pr)
            if local_status then quiet = false end
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
                    local_status = local_status,
                }
            end
        end
        segments({ { margin }, { active .. " to inspect", "PrAttentionTitle" },
            { "   ·   " .. checked .. " checked/deferred   ·   " .. waiting .. " awaiting others", "PrAttentionMuted" } })
        if active == 0 then
            add("")
            add(margin .. "All caught up in this snapshot.", "PrAttentionMuted")
        end
        for index, bucket in ipairs(buckets) do
            table.sort(bucket, function(left, right) return left.pr.url < right.pr.url end)
            if #bucket > 0 then
                add("")
                segments({ { margin .. groups[index], "PrAttentionTitle" }, { "  " .. #bucket, "PrAttentionMuted" } })
            end
            for _, item in ipairs(bucket) do
                local pr = item.pr
                local indent = margin .. string.rep(" ", 4)
                local title = (pr.title or ""):gsub("%c", " ")
                local details = { { margin }, { pad(status_icons[item.status] or "?", 2), "PrAttentionStatus" .. item.status:gsub("%W", "") },
                    { "  " }, { pad(item.label, pr_width), "PrAttentionRepo" }, { "  " },
                    { pad(item.added, added_width, true), "PrAttentionAdded" }, { " " },
                    { pad(item.removed, removed_width, true), "PrAttentionRemoved" } }
                local title_space = width - (#margin + 4 + pr_width + 2 + added_width + 1 + removed_width + 2) - 1
                if title_space >= 18 then
                    if vim.fn.strdisplaywidth(title) > title_space then
                        local length = vim.fn.strchars(title)
                        repeat
                            length = length - 1
                            title = vim.fn.strcharpart(title, 0, length)
                        until vim.fn.strdisplaywidth(title) <= title_space - 1
                        title = title .. "…"
                    end
                    details[#details + 1] = { "  " .. title, "PrAttentionTitle" }
                    segments(details, pr)
                else
                    segments(details, pr)
                    segments({ { indent }, { title, "PrAttentionTitle" } }, pr)
                end
                local reason = item.reason:gsub("%c", " ")
                local parts = { { indent }, { item.status, "PrAttentionStatus" .. item.status:gsub("%W", "") },
                    { "  ·  " .. reason, "PrAttentionMuted" } }
                if item.local_status then
                    local source = item.local_status:find("Ready for review", 1, true) and "DiagnosticHint"
                        or item.local_status:find("Failed", 1, true) and "DiagnosticError" or "DiagnosticWarn"
                    vim.list_extend(parts, { { "  ·  ", "PrAttentionMuted" },
                        { (source == "DiagnosticHint" and " " or source == "DiagnosticError" and " " or " ")
                            .. item.local_status, source }, { "   M report", "PrAttentionMuted" } })
                end
                detail_rows[#lines] = { pr = pr, parts = parts, context = pr_context(pr, snapshot.login, indent, width), blocker =
                    (item.local_status and (item.local_status:find("Needs a decision", 1, true)
                        or item.local_status:find("Failed", 1, true))) or reason:lower():find("fail", 1, true) }
            end
        end
        add("")
        add(margin .. string.rep("─", math.max(1, math.min(width - 2 * #margin, 72))), "PrAttentionRule")
        controls({ { "o", "open" }, { "c", "Codex" }, { "m", "resolve" }, { "M", "report" },
            { "r", "refresh" }, { "?", "keys" } })
        if show_all then add(margin .. "Showing all PRs · a to hide quiet items", "PrAttentionMuted") end
    else
        add("  No PR snapshot available.", "PrAttentionMuted")
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
    if previous then
        for line = 1, #lines do
            local pr = rows[line]
            if pr and pr.url == previous.url then
                vim.api.nvim_win_set_cursor(0, { line, 0 })
                break
            end
        end
    end
    show_details()
end

local function board_window(restore)
    local saved = vim.w.pr_attention_options
    if restore then
        if saved then
            for option, value in pairs(saved) do vim.wo[option] = value end
            vim.w.pr_attention_options = nil
        end
        return
    end
    if saved then return end
    saved = {}
    for option, value in pairs({ number = true, relativenumber = true, signcolumn = "no", foldcolumn = "0",
        wrap = true, linebreak = true, breakindent = true, breakindentopt = "shift:4", cursorline = true,
        list = false, spell = false, colorcolumn = "" }) do
        saved[option] = vim.wo[option]
        vim.wo[option] = value
    end
    vim.w.pr_attention_options = saved
end

local function show_keys()
    scratch("keys", {
        "# PR attention", "", "Status", "    New PR", "    Updated code", "    New activity",
        "    Action required", "    Checked locally", "  󰒲  Deferred", "    Waiting for others",
        "    Previously reviewed", "    Merge candidate", "    Draft", "",
        "Open", "  o  Open in Octo", "  b  Open in the browser",
        "  D  Changes since the last assessment", "  w  Open the worktree", "  c  Open in Codex", "  C  Copy the Codex brief",
        "", "Resolve", "  m  Resolve conflicts or resume with a decision", "  M  Saved report, diff, commit, and push",
        "", "Queue", "  d  Mark this snapshot checked", "  s  Defer until tomorrow", "  u  Undo the local checkpoint",
        "  a  Show or hide quiet PRs", "  r  Refresh", "  q  Close", "", "Press q to return.",
    })
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
    feedback("Loading changes for " .. label(pr) .. "...")
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
        feedback("Opened changes for " .. label(pr) .. ".")
    end)
end

local function open_worktree(pr, on_open, resolve_conflicts)
    if not pr then return end
    if not resolve_conflicts and (not vim.env.TMUX or vim.env.TMUX == "") then
        notify("Open Neovim inside tmux to use the worktree action."); return
    end
    if snapshot.host ~= "github.com" then notify("tsp-pr currently supports github.com repositories only."); return end
    if opening then notify("A PR worktree is already opening."); return end
    opening = true
    feedback("Preparing the worktree for " .. label(pr) .. "...")
    local directory = context_directory
    -- Resolve fresh refs; tsp-pr keeps existing worktrees and their local changes.
    local fields = "baseRefName,headRefName,headRefOid"
        .. (resolve_conflicts and ",author,state,mergeable" or "")
    command({ "pr", "view", pr.url, "--json", fields }, function(output)
        local refs = vim.json.decode(output)
        if refs.headRefOid ~= pr.headRefOid then
            opening = false
            notify("The head changed. Refresh and inspect the new snapshot before opening this worktree."); return
        end
        if resolve_conflicts then
            if not refs.author or refs.author == vim.NIL or refs.author.login ~= snapshot.login or refs.state ~= "OPEN" then
                opening = false
                notify("Conflict resolution requires an open PR that you authored.", vim.log.levels.WARN)
                return
            end
            if refs.mergeable == "MERGEABLE" then
                opening = false
                feedback("GitHub reports no merge conflicts for " .. label(pr) .. ".")
                return
            end
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
                if resolve_conflicts then
                    opening = false
                    on_open(path, refs)
                    return
                end
                vim.system({ "tsp", path }, { cwd = directory, text = true }, vim.schedule_wrap(function(session_result)
                    opening = false
                    if session_result.code ~= 0 then
                        notify(vim.trim(session_result.stderr), vim.log.levels.ERROR)
                    elseif on_open then
                        on_open(path, refs)
                    else
                        feedback("Opened the worktree for " .. label(pr) .. ".")
                    end
                end))
            end))
    end, function() opening = false end)
end

local function conflict_report_path(pr)
    local root = vim.env.XDG_STATE_HOME or vim.fs.joinpath(vim.env.HOME, ".local", "state")
    return vim.fs.joinpath(root, "codex", "pr-attention", snapshot.host, snapshot.login,
        "conflicts", vim.fn.sha256(pr.url) .. ".md")
end

local function local_git(path, args)
    local argv = { "git", "-C", path }
    vim.list_extend(argv, args)
    return vim.system(argv, { text = true, timeout = 10000 }):wait()
end

local function read_conflict(pr)
    local path = conflict_report_path(pr)
    if vim.fn.filereadable(path .. ".json") == 1 then
        local ok, state = pcall(vim.json.decode, table.concat(vim.fn.readfile(path .. ".json"), "\n"))
        if ok and type(state) == "table" and state.url == pr.url then return state end
    elseif vim.fn.filereadable(path) == 1 then
        -- Import reports from the first version without changing the worktree.
        local worktree = table.concat(vim.fn.readfile(path), "\n"):match("\nWorktree: ([^\n]+)")
        if worktree then return { url = pr.url, path = worktree, head = pr.headRefOid, state = "Inspect local merge",
            exit_code = tonumber(table.concat(vim.fn.readfile(path), "\n"):match("Task exit code: (%-?%d+)")) } end
    end
end

local function write_conflict(report_path, state)
    vim.fn.mkdir(vim.fs.dirname(report_path), "p")
    local temporary = report_path .. ".json.tmp"
    vim.fn.writefile({ vim.json.encode(state) }, temporary)
    assert(vim.fn.rename(temporary, report_path .. ".json") == 0, "Cannot save conflict state")
end

conflict_summary = function(pr)
    if conflict_jobs[pr.url] then return "Resolving locally" end
    local state = read_conflict(pr)
    if not state then return end
    if state.head ~= pr.headRefOid and state.commit ~= pr.headRefOid then return "Local report is stale · press M" end
    return state.state .. (state.state == "Ready for review" and " · commit and push pending" or "")
end

local function inspect_conflict(state, exit_code)
    if state.pid and vim.uv.kill(state.pid, 0) ~= nil then
        state.state, state.blocker = "Resolving locally", "Wait for the running task to finish."
        state.unresolved = state.unresolved or {}
        return state
    end
    state.pid = nil
    local head = local_git(state.path, { "rev-parse", "HEAD" })
    local merge = local_git(state.path, { "rev-parse", "--verify", "-q", "MERGE_HEAD" })
    local unresolved = local_git(state.path, { "diff", "--name-only", "--diff-filter=U" })
    state.unresolved = vim.split(vim.trim(unresolved.stdout or ""), "\n", { trimempty = true })
    if state.merge_head and merge.code == 0 and state.merge_head ~= vim.trim(merge.stdout) then
        state.state, state.blocker = "Failed", "The merge target changed. Inspect the checkout before continuing."
        return state
    end
    state.merge_head = merge.code == 0 and vim.trim(merge.stdout) or nil
    if head.code ~= 0 or unresolved.code ~= 0 then
        state.state = "Failed"
        state.blocker = "Cannot inspect the local checkout."
    elseif vim.trim(head.stdout) ~= (state.commit or state.head) then
        state.state, state.blocker = "Failed", "The local HEAD changed. Inspect the checkout before continuing."
    elseif exit_code and exit_code ~= 0 then
        state.state, state.blocker = "Failed", "The resolver failed. Read the task report before retrying."
    elseif #state.unresolved > 0 then
        state.state, state.blocker = "Needs a decision", "Unresolved files: " .. table.concat(state.unresolved, ", ")
    elseif state.commit then
        state.state, state.blocker = state.state == "Published" and "Published" or "Committed locally", nil
    elseif state.merge_head then
        state.state, state.blocker = "Ready for review", nil
    else
        state.state, state.blocker = "Failed", "No local merge is available. Read the task report."
    end
    return state
end

local function fresh_pr(pr, callback)
    command({ "pr", "view", pr.url, "--json",
        "author,state,headRefOid,headRefName,headRepository,headRepositoryOwner,baseRefName" }, function(output)
        local refs = vim.json.decode(output)
        if not refs.author or refs.author == vim.NIL or refs.author.login ~= snapshot.login or refs.state ~= "OPEN" then
            notify("This action requires your own open PR.", vim.log.levels.WARN); return
        end
        callback(refs)
    end)
end

local function publish_conflict(pr, state, report_path, push)
    if conflict_jobs[pr.url] then feedback("Wait for conflict resolution to finish."); return end
    fresh_pr(pr, function(refs)
        inspect_conflict(state, state.exit_code)
        if refs.headRefOid ~= state.head or (push and not state.commit)
            or (not push and state.state ~= "Ready for review") or #state.unresolved > 0 then
            notify("The PR or local merge changed. Reopen M and inspect the result.", vim.log.levels.WARN); return
        end
        local diff = local_git(state.path, { "diff", "--cached", "--binary" })
        local changes = diff.stdout
        if diff.code ~= 0 then notify("Cannot inspect the staged diff.", vim.log.levels.ERROR); return end
        vim.ui.select({ "Cancel", push and "Push reviewed commit" or "Commit reviewed merge" },
            { prompt = push and "Push this commit to the PR branch?" or "Did you review the diff and test results?" }, function(choice, index)
                if not choice or index ~= 2 then return end
                local function run(message)
                    inspect_conflict(state, state.exit_code)
                    local current_diff = local_git(state.path, { "diff", "--cached", "--binary" })
                    if state.state == "Failed" or state.state == "Resolving locally" or #state.unresolved > 0
                        or current_diff.code ~= 0 or current_diff.stdout ~= changes then
                        notify("The checkout changed during confirmation. Inspect it again.", vim.log.levels.WARN); return
                    end
                    local argv = { "git", "-C", state.path }
                    if push then
                        if not refs.headRepository or refs.headRepository == vim.NIL or not refs.headRepositoryOwner
                            or refs.headRepositoryOwner == vim.NIL then
                            notify("Cannot identify the PR source repository.", vim.log.levels.ERROR); return
                        end
                        vim.list_extend(argv, { "push", "--", "https://github.com/" .. refs.headRepositoryOwner.login
                            .. "/" .. refs.headRepository.name .. ".git", state.commit .. ":refs/heads/" .. refs.headRefName })
                    else
                        if state.state ~= "Ready for review" then feedback("The local merge is no longer ready."); return end
                        vim.list_extend(argv, { "commit", "-m", message })
                    end
                    conflict_jobs[pr.url] = true
                    vim.system(argv, { text = true }, vim.schedule_wrap(function(result)
                        conflict_jobs[pr.url] = nil
                        if result.code ~= 0 then notify(vim.trim(result.stderr or "Git action failed"), vim.log.levels.ERROR); return end
                        if push then state.state = "Published"
                        else
                            state.commit = vim.trim(local_git(state.path, { "rev-parse", "HEAD" }).stdout)
                            state.state = "Committed locally"
                        end
                        write_conflict(report_path, state)
                        render()
                        notify(push and "Pushed the reviewed merge. Refresh the queue." or "Committed locally. Press p in the report to push.")
                    end))
                end
                if push then run()
                else vim.ui.input({ prompt = "Commit message: ", default = "chore: resolve merge conflicts" }, function(message)
                    if message and vim.trim(message) ~= "" then run(message) end
                end) end
            end)
    end)
end

local function conflict_report(pr)
    pr = pr or selected()
    if not pr then return end
    local path = conflict_report_path(pr)
    if vim.fn.filereadable(path) == 0 then
        feedback("No conflict report saved for " .. label(pr) .. ".")
        return
    end
    local state = read_conflict(pr)
    local lines = vim.fn.readfile(path)
    if state and not conflict_jobs[pr.url] then
        inspect_conflict(state, state.exit_code)
        write_conflict(path, state)
        render()
        local overview = { "Local status: " .. state.state, state.blocker or "", "",
            "d: inspect diff    m: resume with a decision    c: commit reviewed merge    p: push reviewed commit", "",
            "Tests and resolver decisions appear in the task report below.", "" }
        vim.list_extend(overview, lines)
        lines = overview
    end
    if conflict_jobs[pr.url] then
        table.insert(lines, 1, "The task is still running in the background. Reopen this report with M after it finishes.")
    elseif not table.concat(lines, "\n"):find("Task exit code:", 1, true) and vim.fn.filereadable(path .. ".output") == 1 then
        local output = vim.fn.readfile(path .. ".output")
        if #output > 0 then
            vim.list_extend(lines, { "", "## Saved Codex response", "", "The original task exit status is unavailable.", "" })
            vim.list_extend(lines, output)
        end
    end
    local buffer = scratch("conflicts-" .. pr.number, lines)
    if state then
        vim.keymap.set("n", "m", function() resolve_conflicts(pr) end, { buffer = buffer })
        vim.keymap.set("n", "d", function()
            local staged = local_git(state.path, { "diff", "--cached" })
            local unstaged = local_git(state.path, { "diff" })
            scratch("merge-diff-" .. pr.number, vim.split((staged.stdout or "") .. "\n" .. (unstaged.stdout or ""), "\n"), "diff")
        end, { buffer = buffer })
        vim.keymap.set("n", "c", function() publish_conflict(pr, state, path, false) end, { buffer = buffer })
        vim.keymap.set("n", "p", function() publish_conflict(pr, state, path, true) end, { buffer = buffer })
    end
end

resolve_conflicts = function(pr)
    pr = pr or selected()
    if not pr then return end
    if not pr.author or pr.author == vim.NIL or pr.author.login ~= snapshot.login then
        notify("Conflict resolution is available for your own PRs only.", vim.log.levels.WARN)
        return
    end
    if conflict_jobs[pr.url] then
        feedback("Conflict resolution is already running for " .. label(pr) .. ". Press M for its report."); return
    end
    if vim.fn.executable("codex") ~= 1 then notify("The codex executable is not available.", vim.log.levels.ERROR); return end
    local report_path = conflict_report_path(pr)
    local previous = read_conflict(pr)
    local function start(path, refs, decision)
        local prior_report = decision and table.concat(vim.fn.readfile(report_path), "\n") or ""
        local prompt = table.concat({
            "Resolve all merge conflicts locally for my PR: " .. pr.url,
            "Expected PR head: " .. pr.headRefOid,
            "Base branch: " .. refs.baseRefName,
            decision and ("Expected MERGE_HEAD: " .. previous.merge_head) or "",
            "You are authorized to fetch the current base branch, start a local merge, and edit conflict resolutions.",
            "Read the repository instructions and inspect the PR intent before resolving conflicts.",
            decision and "Resume the existing local merge. Preserve its resolved files and all existing local changes."
                or "First verify the checkout matches the expected head and has no local changes or unfinished Git operations.",
            "If any precondition fails, stop and explain the blocker. Preserve all existing work.",
            decision and "Verify the existing MERGE_HEAD. Continue only the recorded merge."
                or "Resolve the base repository and branch from fresh PR metadata. Fetch that base, including for a fork PR.",
            decision and "Do not start another merge or fetch a different base into this merge. Do not rebase or rewrite history."
                or "Merge the fetched base into this PR with --no-commit --no-ff. Do not rebase or rewrite history.",
            "Resolve each conflict from the intent of both changes. Do not choose ours or theirs for all files.",
            "If a resolution requires an unclear product decision, leave that conflict unresolved and explain the decision needed.",
            "Run the relevant tests and inspect the final diff for conflict markers and unintended changes.",
            "Do not commit, push, post comments, or merge the PR on GitHub. Leave the local merge for my review.",
            "Report the resolved files, remaining conflicts, test results, and any decisions that need my input.",
            decision and ("User decision for this continuation: " .. decision .. "\nPrevious report:\n" .. prior_report) or "",
        }, "\n")
        local id = "pr_attention_conflicts_" .. pr.url
        local output_path = report_path .. ".output"
        local heading = { "# Conflict resolution: " .. label(pr), "", "Worktree: " .. path,
            "Started: " .. os.date("%Y-%m-%d %H:%M:%S"), "",
            "Inspect the local merge before committing or pushing.", "" }
        local saved, save_error = pcall(function()
            vim.fn.mkdir(vim.fs.dirname(report_path), "p")
            vim.fn.writefile(vim.list_extend(vim.deepcopy(heading), {
                "Task started in the background. Completion appears through a Neovim notification.",
                "After a Neovim restart, live task status is unavailable here.",
            }), report_path)
            vim.fn.writefile({}, output_path)
        end)
        if not saved then notify("Cannot save conflict report: " .. tostring(save_error), vim.log.levels.ERROR); return end
        local state = { url = pr.url, path = path, head = pr.headRefOid, state = "Resolving locally" }
        write_conflict(report_path, state)
        conflict_jobs[pr.url] = true
        render()
        progress_notice("Resolving conflicts for " .. label(pr) .. " in the background. Press M for the report.\n"
            .. "Worktree: " .. path, id)
        local function save_report(result)
            local report = vim.fn.readfile(output_path)
            if #report == 0 then report = vim.split(vim.trim(result.stdout or ""), "\n", { plain = true }) end
            if #report == 0 or (#report == 1 and report[1] == "") then report = { "Codex returned no report." } end
            vim.list_extend(report, { "", "Task exit code: " .. result.code })
            if result.code ~= 0 then
                vim.list_extend(report, { "", vim.trim(result.stderr or "") })
            end
            local written, err = pcall(vim.fn.writefile, vim.list_extend(vim.deepcopy(heading), report), report_path)
            if not written then notify("Cannot save conflict report: " .. tostring(err), vim.log.levels.ERROR) end
        end
        local ok, process = pcall(vim.system, { "codex", "exec", "--cd", path, "--color", "never",
            "--output-last-message", output_path, prompt },
            { cwd = path, text = true }, vim.schedule_wrap(function(result)
                conflict_jobs[pr.url] = nil
                state.pid = nil
                save_report(result)
                state.exit_code = result.code
                inspect_conflict(state, result.code)
                write_conflict(report_path, state)
                render()
                notify(state.state .. ": " .. label(pr)
                    .. ". Press M in PR attention to inspect the saved report.\nWorktree: " .. path,
                    state.state == "Ready for review" and vim.log.levels.INFO or vim.log.levels.WARN, { id = id })
            end))
        if not ok then
            conflict_jobs[pr.url] = nil
            save_report({ code = -1, stderr = tostring(process) })
            state.state, state.exit_code = "Failed", -1
            write_conflict(report_path, state)
            notify("Cannot start conflict resolution: " .. tostring(process), vim.log.levels.ERROR, { id = id })
        elseif process and process.pid then
            state.pid = process.pid
            write_conflict(report_path, state)
        end
    end
    if previous then
        inspect_conflict(previous, previous.exit_code)
        write_conflict(report_path, previous)
        if previous.state == "Resolving locally" then feedback("Conflict resolution is already running. Press M for its report."); return end
        if previous.state == "Ready for review" or previous.commit then
            feedback("The merge is already resolved locally. Press M to review, commit, or push."); return
        end
        if previous.merge_head then
            if previous.head ~= pr.headRefOid or local_git(previous.path, { "rev-parse", "HEAD" }).stdout:gsub("%s+$", "") ~= pr.headRefOid then
                notify("The PR head changed. Inspect the existing merge before resuming.", vim.log.levels.WARN); return
            end
            if vim.bo.filetype == "pr_attention" then conflict_report(pr) end
            vim.ui.input({ prompt = "Decision or instructions for the remaining conflict: " }, function(decision)
                if not decision or vim.trim(decision) == "" then return end
                fresh_pr(pr, function(refs)
                    local current = inspect_conflict(vim.deepcopy(previous))
                    if refs.headRefOid ~= previous.head or current.merge_head ~= previous.merge_head or current.state == "Failed" then
                        notify("The PR or merge changed. Inspect it before resuming.", vim.log.levels.WARN); return
                    end
                    start(previous.path, refs, decision)
                end)
            end)
            return
        end
    end
    open_worktree(pr, start, true)
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
    scratch("codex-brief", vim.list_extend({ "# Codex brief", "" }, prompt))
    notify("Copied the brief to the clipboard. Paste it into the PR worktree's Codex window.")
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
        feedback("Sending the brief for " .. label(pr) .. " to Codex...")
        require("helpers.codex").send(payload, { directory = path, focus = true, wait_ms = 10000 })
    end)
end

function M.refresh()
    if loading then feedback("A queue refresh is already in progress."); return end
    loading = true
    generation = generation + 1
    local request = generation
    local request_directory = vim.fn.getcwd()
    progress_notice(snapshot and "Refreshing PR queue..." or "Loading PR queue...")
    require("helpers.pr_inbox").collect(function(result)
        if request ~= generation then return end
        context_directory = request_directory
        loading, snapshot, checkpoints = false, result, {}
        for _, pr in ipairs(result.prs) do
            local record, err = memory.read(result.host, result.login, pr.url)
            checkpoints[pr.url] = record
            if err then notify(err, vim.log.levels.WARN) end
            local state = read_conflict(pr)
            if state and not conflict_jobs[pr.url] then
                inspect_conflict(state, state.exit_code)
                write_conflict(conflict_report_path(pr), state)
            end
        end
        render()
        refresh_result("PR queue refreshed.")
    end, function(message)
        if request ~= generation then return end
        loading = false
        refresh_result("Refresh failed. " .. (snapshot and "The previous snapshot remains visible. " or "")
            .. message, vim.log.levels.ERROR)
    end)
end

function M.open()
    if not board or not vim.api.nvim_buf_is_valid(board) then
        board = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(board, "pr-attention://daily")
        vim.bo[board].bufhidden = "hide"
        vim.bo[board].swapfile = false
        vim.bo[board].filetype = "pr_attention"
        vim.api.nvim_create_autocmd("BufWinEnter", { buffer = board, callback = function() board_window(false) end })
        vim.api.nvim_create_autocmd("BufWinLeave", { buffer = board, callback = function() board_window(true) end })
        vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, { buffer = board, callback = show_details })
        local actions = {
            o = function()
                local pr = selected()
                if pr then
                    feedback("Opening " .. label(pr) .. " in Octo...")
                    require("octo.utils").get_pull_request(pr.number, pr.repository.nameWithOwner)
                end
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
                feedback("Cleared the local checkpoint for " .. label(pr) .. ".")
            end,
            r = M.refresh,
            a = function()
                show_all = not show_all
                render()
                feedback(show_all and "Showing all PRs." or "Showing PRs that need attention.")
            end,
            D = changes, w = function() open_worktree(selected()) end, c = send_brief, C = copy_brief,
            m = resolve_conflicts, M = conflict_report,
            ["?"] = show_keys,
            b = function()
                local pr = selected()
                if not pr then return end
                local process, err = vim.ui.open(pr.url)
                if not process then notify(tostring(err), vim.log.levels.ERROR); return end
                feedback("Asked the browser to open " .. label(pr) .. ".")
            end,
            q = function() vim.cmd("enew"); feedback("Closed PR attention.") end,
        }
        for key, action in pairs(actions) do
            vim.keymap.set("n", key, action, { buffer = board, silent = true, desc = "PR attention: " .. key })
        end
    end
    vim.api.nvim_set_current_buf(board)
    board_window(false)
    render()
    M.refresh()
end

function M.setup()
    vim.api.nvim_create_user_command("PrAttention", M.open, { desc = "Daily PR queue with local review checkpoints" })
end

return M
