local M = {}
local state = require("helpers.pr_inbox_state")
local snapshot
local pending

local function cache_context()
    local config = require("octo.config").values
    local directory = vim.env.GH_CONFIG_DIR or vim.fs.joinpath(vim.env.XDG_CONFIG_HOME
        or vim.fs.joinpath(vim.env.HOME, ".config"), "gh")
    local stat = vim.uv.fs_stat(vim.fs.joinpath(directory, "hosts.yml"))
    local account = vim.system({ "git", "config", "--get", "gh.user" }, { text = true }):wait()
    -- Account switches update hosts.yml. Hash the context without storing tokens
    -- or reading credential files, and never reuse another account's snapshot.
    return vim.fn.sha256(vim.json.encode({
        command = config.gh_cmd, host = config.github_hostname, environment = config.gh_env,
        token = vim.env.GH_TOKEN or vim.env.GITHUB_TOKEN, gh_host = vim.env.GH_HOST,
        config_directory = directory, modified = stat and stat.mtime,
        repository_account = account.code == 0 and vim.trim(account.stdout) or "",
        working_directory = vim.fn.getcwd(),
    }))
end

local titles = {
    all = "Combined PR inbox",
    review = "Needs your review",
    team = "Needs your teams' review",
    drafts = "Your drafts",
    waiting = "Waiting for review or checks",
    action = "Needs action",
    ready = "Ready to merge",
}

local badges = {
    review = { "REVIEW", "100;180;255" },
    team = { "TEAM", "190;155;255" },
    drafts = { "DRAFT", "175;185;200" },
    waiting = { "WAITING", "255;210;110" },
    action = { "ACTION", "255;125;145" },
    ready = { "MERGE", "120;220;160" },
}

local function strip_color(text)
    return (text:gsub("\27%[[%d;]*m", ""))
end

local function group_badges(categories)
    local labels = {}
    for _, category in ipairs(categories) do
        local badge = badges[category]
        labels[#labels + 1] = "\27[1;38;2;20;22;30;48;2;" .. badge[2] .. "m " .. badge[1] .. " \27[0m"
    end
    return table.concat(labels, " ")
end

local search_fields = [[
    issueCount
    pageInfo { hasNextPage endCursor }
    nodes {
      ... on PullRequest {
        number title url state isDraft headRefOid
        mergeable mergeStateStatus reviewDecision isInMergeQueue
        repository { nameWithOwner }
        commits(last: 1) {
          nodes { commit { statusCheckRollup { state } } }
        }
      }
    }
]]

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "PR inbox" })
end

local function graphql(query, variables, callback, on_error)
    local function fail(message)
        if on_error then on_error(message) else notify(message, vim.log.levels.ERROR) end
    end
    local config = require("octo.config").values
    local command = { config.gh_cmd or "gh", "api", "graphql", "--input", "-" }
    if config.github_hostname and config.github_hostname ~= "" then
        vim.list_extend(command, { "--hostname", config.github_hostname })
    end
    vim.system(command, {
        text = true,
        timeout = 30000,
        env = config.gh_env,
        stdin = vim.json.encode({ query = query, variables = variables }),
    }, vim.schedule_wrap(function(result)
        if result.code ~= 0 then
            fail(vim.trim(result.stderr or "") ~= "" and vim.trim(result.stderr) or "GitHub request failed.")
            return
        end
        local ok, response = pcall(vim.json.decode, result.stdout)
        if not ok or type(response) ~= "table" then
            fail("GitHub returned an invalid response.")
            return
        end
        if response.errors and response.errors ~= vim.NIL and #response.errors > 0 then
            fail(response.errors[1].message)
            return
        end
        if type(response.data) ~= "table" then
            fail("GitHub returned no data.")
            return
        end
        callback(response.data)
    end))
end

local function show(group, prs, updated_at, refreshing)
    local items = {}
    local group_width = 0
    for _, pr in ipairs(prs) do
        local _, reason = state.classify(pr)
        if group == "all" or vim.tbl_contains(pr.inbox_categories, group) then
            if group == "all" then
                pr.group_badges = group_badges(pr.inbox_categories)
                group_width = math.max(group_width, vim.fn.strdisplaywidth(strip_color(pr.group_badges)))
                pr.text = string.format("%s#%d  %s", pr.repository.nameWithOwner, pr.number, pr.title)
            else
                pr.text = string.format("%s#%d  %s  [%s]", pr.repository.nameWithOwner, pr.number, pr.title, reason)
            end
            items[#items + 1] = pr
        end
    end
    if #items == 0 then
        notify("No PRs: " .. titles[group])
        return
    end
    local lines, by_line, preview_entries = {}, {}, {}
    for _, item in ipairs(items) do
        local line = item.text:gsub("%c", " ")
        if group == "all" then
            local width = vim.fn.strdisplaywidth(strip_color(item.group_badges))
            line = item.group_badges .. string.rep(" ", group_width - width) .. "  │  " .. line
        end
        lines[#lines + 1] = line
        local key = strip_color(line)
        by_line[key] = item
        preview_entries[key] = {
            value = item.number,
            repo = item.repository.nameWithOwner,
            kind = "pull_request",
            ordinal = key,
            obj = item,
        }
    end
    local function selected_action(action)
        return function(selected)
            local item = selected and selected[1] and by_line[strip_color(selected[1])]
            if item then action(item) end
        end
    end
    local header = "Ctrl-r: refresh from GitHub"
    if updated_at then
        header = string.format("Snapshot: %ds old%s  |  %s", os.time() - updated_at,
            refreshing and " (background refresh requested)" or "", header)
    end
    require("fzf-lua").fzf_exec(lines, {
        prompt = string.format("%s (%d)> ", titles[group], #items),
        header = header,
        previewer = require("octo.pickers.fzf-lua.previewers").issue(preview_entries),
        fzf_opts = { ["--no-multi"] = true, ["--ansi"] = true },
        actions = {
            ["enter"] = selected_action(function(item)
                require("octo.utils").get_pull_request(item.number, item.repository.nameWithOwner)
            end),
            ["ctrl-b"] = selected_action(function(item) vim.ui.open(item.url) end),
            ["ctrl-y"] = selected_action(function(item) vim.fn.setreg("+", item.url) end),
            ["ctrl-e"] = selected_action(function(item) vim.fn.setreg("+", item.headRefOid) end),
            ["ctrl-r"] = function() M.open(group, { refresh = true }) end,
        },
        -- Override the global ctrl-e cursor-motion binding for this picker.
        keymap = { fzf = { ["ctrl-e"] = false } },
    })
end

local function filter_for(group, login)
    if group == "review" then
        return "user-review-requested:" .. login
    elseif group == "team" then
        return "team-review-requested-user:" .. login
    end
    return "author:" .. login
end

local function fetch_combined(callback, on_error)
    -- Batch the three sources in one request. Only unfinished sources need
    -- another request when there are more than 50 results.
    local sources = { "review", "team", "authored" }
    local results, seen, after, complete = {}, {}, {}, {}
    for _, source in ipairs(sources) do
        results[source], seen[source] = {}, {}
    end
    local function batch()
        local definitions, fields, variables = {}, {}, {}
        for _, source in ipairs(sources) do
            if not complete[source] then
                definitions[#definitions + 1] = "$" .. source .. "Search: String!, $" .. source .. "After: String"
                fields[#fields + 1] = source .. ": search(query: $" .. source
                    .. "Search, type: ISSUE, first: 50, after: $" .. source .. "After) {" .. search_fields .. "}"
                variables[source .. "Search"] = "is:pr is:open " .. filter_for(source, "@me") .. " sort:updated-desc"
                variables[source .. "After"] = after[source] or vim.NIL
            end
        end
        local query = "query(" .. table.concat(definitions, ", ") .. ") {" .. table.concat(fields, "\n") .. "}"
        graphql(query, variables, function(data)
            local more = false
            for _, source in ipairs(sources) do
                if not complete[source] then
                    local connection = data[source]
                    for _, pr in ipairs(connection.nodes) do
                        if pr ~= vim.NIL and pr.url and pr.state == "OPEN" and not seen[source][pr.url] then
                            seen[source][pr.url] = true
                            results[source][#results[source] + 1] = pr
                        end
                    end
                    complete[source] = not connection.pageInfo.hasNextPage or #results[source] >= 1000
                    after[source] = connection.pageInfo.endCursor
                    if complete[source] and connection.issueCount > 1000 then
                        notify("GitHub search limits " .. source .. " to 1,000 PRs. Results are incomplete.", vim.log.levels.WARN)
                    end
                    more = more or not complete[source]
                end
            end
            if more then
                batch()
                return
            end
            local combined, by_url = {}, {}
            for _, source in ipairs(sources) do
                for _, pr in ipairs(results[source]) do
                    local item = by_url[pr.url]
                    if not item then
                        item = pr
                        item.inbox_categories = {}
                        by_url[pr.url] = item
                        combined[#combined + 1] = item
                    end
                    local category = source == "authored" and state.classify(pr) or source
                    item.inbox_categories[#item.inbox_categories + 1] = category
                end
            end
            callback(combined)
        end, on_error)
    end
    batch()
end

local function load_snapshot(callback, quiet)
    local context = cache_context()
    if pending and pending.context == context then
        pending.callbacks[#pending.callbacks + 1] = { success = callback, quiet = quiet }
        return
    end
    local request = { context = context, callbacks = { { success = callback, quiet = quiet } } }
    pending = request
    -- Snapshot refreshes always go to GitHub. Reopening the picker does not.
    fetch_combined(function(prs)
        if pending == request then pending = nil end
        if cache_context() ~= context then return end
        snapshot = { context = context, prs = prs, updated_at = os.time() }
        for _, waiter in ipairs(request.callbacks) do
            if waiter.success then waiter.success(snapshot) end
        end
    end, function(message)
        if pending == request then pending = nil end
        for _, waiter in ipairs(request.callbacks) do
            if not waiter.quiet then
                notify(message, vim.log.levels.ERROR)
                break
            end
        end
    end)
end

---Warm every PR list without opening a picker or reporting background errors.
function M.prefetch()
    if snapshot and snapshot.context == cache_context() and os.time() - snapshot.updated_at < 30 then return end
    load_snapshot(nil, true)
end

function M.setup()
    if #vim.api.nvim_list_uis() == 0 then return end
    local group = vim.api.nvim_create_augroup("PrInboxPrefetch", { clear = true })
    vim.api.nvim_create_autocmd("FocusGained", { group = group, callback = M.prefetch })
    vim.defer_fn(function()
        if vim.v.exiting == vim.NIL then M.prefetch() end
    end, 1000)
end

function M.open(group, options)
    options = options or {}
    assert(titles[group], "Unknown PR inbox group: " .. tostring(group))
    if not options.refresh and snapshot and snapshot.context == cache_context() then
        local stale = os.time() - snapshot.updated_at >= 30
        if stale then M.prefetch() end
        show(group, snapshot.prs, snapshot.updated_at, stale)
        return
    end
    notify("Loading " .. titles[group] .. "...")
    load_snapshot(function(result) show(group, result.prs, result.updated_at) end, false)
end

return M
