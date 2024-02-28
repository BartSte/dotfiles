local keymapper = require('helpers.keymapper')

-- Set autopep8 to be the formatter for the gq command.
vim.opt_local.formatprg = 'autopep8 -'

-- map leader + f to format the entire file. This can be done using gggqG, but
-- we need to make sure the cursor is returned its original position.
local function format_file()
    local cursor = vim.fn.getpos('.')
    if cursor == nil then
        vim.notify('Cursor position not found', vim.log.levels.ERROR)
    else
        vim.cmd('normal! gggqG')
        vim.fn.setpos('.', cursor)
    end
end
keymapper.buffer_nnoremap('<leader>f', format_file)
