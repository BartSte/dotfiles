local M = {}
local state = require("helpers.pr_inbox_state")

local titles = {
    all = "Combined PR inbox",
    review = "Needs your review",
    team = "Needs your teams' review",
    drafts = "Your drafts",
    waiting = "Waiting for review or checks",
    action = "Needs action",
    ready = "Ready to merge",
}

local search_query = [[
query($search: String!, $after: String) {
  search(query: $search, type: ISSUE, first: 50, after: $after) {
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
  }
}
]]

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "PR inbox" })
end

local function graphql(query, variables, callback)
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
            notify(vim.trim(result.stderr or "") ~= "" and vim.trim(result.stderr)
                or "GitHub request failed.", vim.log.levels.ERROR)
            return
        end
        local ok, response = pcall(vim.json.decode, result.stdout)
        if not ok or type(response) ~= "table" then
            notify("GitHub returned an invalid response.", vim.log.levels.ERROR)
            return
        end
        if response.errors and response.errors ~= vim.NIL and #response.errors > 0 then
            notify(response.errors[1].message, vim.log.levels.ERROR)
            return
        end
        if type(response.data) ~= "table" then
            notify("GitHub returned no data.", vim.log.levels.ERROR)
            return
        end
        callback(response.data)
    end))
end

---Fetch every available search page; do not silently truncate at one page.
local function fetch(search, callback)
    local results = {}
    local seen = {}
    local function page(after)
        graphql(search_query, { search = search, after = after or vim.NIL }, function(data)
            local connection = data.search
            for _, pr in ipairs(connection.nodes) do
                if pr ~= vim.NIL and pr.url and pr.state == "OPEN" and not seen[pr.url] then
                    seen[pr.url] = true
                    results[#results + 1] = pr
                end
            end
            if connection.pageInfo.hasNextPage and #results < 1000 then
                page(connection.pageInfo.endCursor)
            else
                if connection.issueCount > 1000 then
                    notify("GitHub search limits this list to 1,000 PRs. Results are incomplete.", vim.log.levels.WARN)
                end
                callback(results)
            end
        end)
    end
    page()
end

local function show(group, prs)
    local items = {}
    for _, pr in ipairs(prs) do
        local category, reason = state.classify(pr)
        if group == "all" or group == "review" or group == "team" or category == group then
            if group == "all" then
                reason = table.concat(pr.inbox_groups, "; ")
                pr.text = string.format("%s  |  %s#%d  %s", reason, pr.repository.nameWithOwner, pr.number, pr.title)
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
        lines[#lines + 1] = line
        by_line[line] = item
        preview_entries[line] = {
            value = item.number,
            repo = item.repository.nameWithOwner,
            kind = "pull_request",
            ordinal = line,
            obj = item,
        }
    end
    local function selected_action(action)
        return function(selected)
            local item = selected and by_line[selected[1]]
            if item then action(item) end
        end
    end
    require("fzf-lua").fzf_exec(lines, {
        prompt = string.format("%s (%d)> ", titles[group], #items),
        previewer = require("octo.pickers.fzf-lua.previewers").issue(preview_entries),
        fzf_opts = { ["--no-multi"] = true },
        actions = {
            ["enter"] = selected_action(function(item)
                require("octo.utils").get_pull_request(item.number, item.repository.nameWithOwner)
            end),
            ["ctrl-b"] = selected_action(function(item) vim.ui.open(item.url) end),
            ["ctrl-y"] = selected_action(function(item) vim.fn.setreg("+", item.url) end),
            ["ctrl-e"] = selected_action(function(item) vim.fn.setreg("+", item.headRefOid) end),
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

local function fetch_combined(login)
    -- The authored query covers all four authored groups in one request.
    local sources = { "review", "team", "authored" }
    local combined, by_url = {}, {}
    local function next_source(index)
        local source = sources[index]
        if not source then
            show("all", combined)
            return
        end
        fetch("is:pr is:open " .. filter_for(source, login) .. " sort:updated-desc", function(prs)
            for _, pr in ipairs(prs) do
                local item = by_url[pr.url]
                if not item then
                    item = pr
                    item.inbox_groups = {}
                    by_url[pr.url] = item
                    combined[#combined + 1] = item
                end
                local label = titles[source]
                if source == "authored" then
                    local category, reason = state.classify(pr)
                    label = titles[category] .. ": " .. reason
                end
                item.inbox_groups[#item.inbox_groups + 1] = label
            end
            next_source(index + 1)
        end)
    end
    next_source(1)
end

function M.open(group)
    assert(titles[group], "Unknown PR inbox group: " .. tostring(group))
    notify("Loading " .. titles[group] .. "...")
    graphql("query { viewer { login } }", {}, function(data)
        local login = data.viewer.login
        if group == "all" then
            fetch_combined(login)
            return
        end
        fetch("is:pr is:open " .. filter_for(group, login) .. " sort:updated-desc", function(prs)
            show(group, prs)
        end)
    end)
end

return M
