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

local function get_fold_range_at_cursor(node_type)
    local node = Files.get_node_at_cursor()
    while node and node:type() ~= node_type do
        node = node:parent()
    end
    local startfold, _, endfold, _ = node:range()
    return startfold, endfold
end

local function get_fold_under_cursor()
    local foldstart, foldend = get_fold_range_at_cursor('section')
    local lines = vim.api.nvim_buf_get_lines(0, foldstart, foldend, true)
    return table.concat(lines, '\n')
end

M.export = function(exporter)
    local org_agenda_item = get_fold_under_cursor(0)
    os.execute("echo " .. org_agenda_item .. " | org2khal new outlook_local")
    --TODO finalize command!
    local command = {'echo', 'foo'}
    return exporter(command, '', M.success, M.error)
end

return M
