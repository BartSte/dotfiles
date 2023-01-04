local Files = require('orgmode.parser.files')

local M = {}

M.success = function(output)
    print('Success!')
    vim.api.nvim_echo({ { table.concat(output, '\n') } }, true, {})
end

M.error = function(err)
    print('Error!')
    vim.api.nvim_echo({ { table.concat(err, '\n'), 'ErrorMsg' } }, true, {})
end

local function get_fold_range_under_cursor()
    --TODO refactor
    local node = Files.get_node_at_cursor()
    if not node then
        return 0, 0
    end
    while node and node:type() ~= 'section' do
        node = node:parent()
    end
    if not node then
        return 0, 0
    end
    local startfold, _, endfold, _ = node:range()
    return startfold, endfold
end

M.get_fold_under_cursor = function()
    local foldstart, foldend = get_fold_range_under_cursor() 
    local lines = vim.api.nvim_buf_get_lines(0, foldstart, foldend, true)
    return table.concat(lines, '\n')
end

M.export = function(exporter)
    local org_agenda_item = M.get_fold_under_cursor(0)
    -- local calendar = ""
    -- local location = ""
    -- local recurrance = ""
    -- local until_ = ""
    -- local alarms = ""

    -- local command = {
    --     "khal", "new",
    --     "--calendar", calendar,
    --     "--location", location,
    --     "--repeat", recurrance,
    --     "--until", until_,
    --     "--alarms", alarms
    -- }
    local command = {"echo", "Test"}
    print(org_agenda_item)
    return exporter(command, '', M.success, M.error)
end

return M
--
--Usage: khal new [OPTIONS] [START [END | DELTA] [TIMEZONE] [SUMMARY] [::
--                DESCRIPTION]]

--  Create a new event from arguments.

--  START and END can be either dates, times or datetimes, please have a look at
--  the man page for details. Everything that cannot be interpreted as a
--  (date)time or a timezone is assumed to be the event's summary, if two colons
--  (::) are present, everything behind them is taken as the event's
--  description.

--Options:
--  -a, --calendar CAL
--  -i, --interactive      Add event interactively
--  -l, --location TEXT    The location of the new event.
--  -g, --categories TEXT  The categories of the new event, comma separated.
--  -r, --repeat TEXT      Repeat event: daily, weekly, monthly or yearly.
--  -u, --until TEXT       Stop an event repeating on this date.
--  -f, --format TEXT      The format to print the event.
--  -m, --alarms TEXT      Alarm times for the new event as DELTAs comma
--                         separated
--  --url TEXT             URI for the event.
--  --help                 Show this message and exit.
