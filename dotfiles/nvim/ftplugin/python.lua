local executable = vim.fn['executable']

if executable('autopep8') == 1 then
    vim.bo.formatprg = 'autopep8 -'
else
    local opts = { buffer = true }
    local message = '<cmd>echo "No autopep8 installed"<CR>'
    vim.keymap.set('n', 'gq', message, opts)
    vim.keymap.set('n', '<space>f', message, opts)
end
