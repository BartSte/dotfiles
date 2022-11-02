local executable = vim.fn['executable']

if executable('autopep8') then
    vim.bo.formatprg = 'autopep8 -'
end

