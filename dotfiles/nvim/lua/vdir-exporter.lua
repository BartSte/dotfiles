local M = {}

M.command = {"org2vdir", "Test exporer"}

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
    local target = vim.fn.fnamemodify(current_file, ':p:r') .. '.rtf'
    return exporter(M.command, target, M.success, M.error)
end

return M
