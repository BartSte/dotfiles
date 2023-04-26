local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local cmp_nvim_lsp = require('cmp_nvim_lsp')

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    cmp_nvim_lsp.default_capabilities()
)

local config_virtual_text = { severity = vim.diagnostic.severity.ERROR }
local config_virtual_text_hint = { severity = vim.diagnostic.severity.HINT }
vim.diagnostic.config({
    virtual_text = config_virtual_text,
    signs = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)


local virtual_text = true
function toggle_virtual_text()
    virtual_text = not virtual_text
    if virtual_text then
        vim.diagnostic.config({virtual_text = config_virtual_text})
    else
        vim.diagnostic.config({virtual_text = false})
    end
end

function set_virtual_text_hint()
    virtual_text = true
    vim.diagnostic.config({virtual_text = config_virtual_text_hint})
end

vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>lua toggle_virtual_text()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><leader>v', '<cmd>lua set_virtual_text_hint()<CR>', {noremap = true})
