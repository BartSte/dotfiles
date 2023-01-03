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

local M = {}

M.command = { "khal", "new", "--calendar", "", "--location", "", "--repeat", "", "--until", "", "--alarms", "" }

M.success = function(output)
    print('Success!')
    vim.api.nvim_echo({ { table.concat(output, '\n') } }, true, {})
end

M.error = function(err)
    print('Error!')
    vim.api.nvim_echo({ { table.concat(err, '\n'), 'ErrorMsg' } }, true, {})
end

M.export = function(exporter)
    local current_file = vim.api.nvim_buf_get_name(0)

    local target = vim.fn.fnamemodify(current_file, ':p:r') .. '.ics'
    return exporter(M.command, target, M.success, M.error)
end

return M
