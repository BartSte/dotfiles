local m = require("helpers.keymapper")
local snacks = require("snacks")

local notifier = {
    timeout = 3000, -- default timeout in ms
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    -- editor margin to keep free. tabline and statusline are taken into account automatically
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true,              -- add 1 cell of left/right padding to the notification window
    sort = { "level", "added" }, -- sort by level and time

    -- minimum log level to display. TRACE is the lowest
    -- all notifications are stored in history
    level = vim.log.levels.TRACE,
    icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
    },
    keep = function(notif)
        return vim.fn.getcmdpos() > 0
    end,
    ---@type snacks.notifier.style

    style = "compact",
    top_down = true,    -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    -- format for footer when more lines are available
    -- `%d` is replaced with the number of lines.
    -- only works for styles with a border
    ---@type string|boolean
    more_format = " ↓ %d lines ",
    refresh = 50, -- refresh at most every 50ms
}

snacks.setup {
    bigfile = { enable = true },
    quickfile = { exclude = { "latex" } },
    notifier = notifier,
}

m.nnoremap("<space>qq", Snacks.bufdelete.delete)
m.nnoremap("<space>qo", Snacks.bufdelete.other)
m.nnoremap("<space>qa", Snacks.bufdelete.all)

m.nnoremap("<space>go", Snacks.gitbrowse.open)
m.nnoremap("<space>gO", Snacks.gitbrowse.get_url)

m.nnoremap("<space>nh", Snacks.notifier.show_history)
