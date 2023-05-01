function set_virtual_text_off()
    vim.diagnostic.config({ virtual_text = false })
end

function set_virtual_text_error()
    vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR } })
end

function set_virtual_text_all()
    vim.diagnostic.config({
        virtual_text = {
            severity = {
                vim.diagnostic.severity.HINT,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.ERROR
            }
        }
    })
end

local function mappings()
    local function bufmap(mode, lhs, rhs)
        local opts = { buffer = true }
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', '<a-k>', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>wincmd v<bar>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gx', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', '<leader>p', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('i', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<cr>')

    bufmap('n', '<leader>vo', '<cmd>lua set_virtual_text_off()<CR>')
    bufmap('n', '<leader>ve', '<cmd>lua set_virtual_text_error()<CR>')
    bufmap('n', '<leader>va', '<cmd>lua set_virtual_text_all()<CR>')
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = mappings
})
