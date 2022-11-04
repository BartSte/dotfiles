local executable = vim.fn['executable']
local opts = { buffer = true }

vim.keymap.set('n', '<leader>i', '<cmd>PyrightOrganizeImports<CR>', opts)

if executable('autopep8') == 1 then
    vim.bo.formatprg = 'autopep8 --aggressive --experimental --global-config ~/dotfiles/.pydocstyle -'
else
    local message = '<cmd>echo "No autopep8 installed"<CR>'
    vim.keymap.set('n', 'gq', message, opts)
    vim.keymap.set('n', '<space>f', message, opts)
end
