local function set_underline_off()
    vim.diagnostic.config({ underline = false })
end

local function set_underline_error()
    vim.diagnostic.config({ underline = { severity = vim.diagnostic.severity.ERROR } })
end

local function set_underline_all()
    vim.diagnostic.config({
        underline = {
            severity = {
                vim.diagnostic.severity.HINT,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.ERROR
            }
        }
    })
end

local function set_virtual_text_off()
    vim.diagnostic.config({ virtual_text = false })
end

local function set_virtual_text_error()
    vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR } })
end

local function set_virtual_text_all()
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

local function format()
    vim.lsp.buf.format({
        filter = require("projectrc").require("config.lsp.format").filter,
        timeout_ms = 5000,
        async = false
    })
end

local function mappings()
    local function bufmap(mode, lhs, rhs)
        local opts = { buffer = true }
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>wincmd v<cr><cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', '<leader>lp', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('i', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '<leader>lf', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<leader>luo', set_underline_off)
    bufmap('n', '<leader>lue', set_underline_error)
    bufmap('n', '<leader>lua', set_underline_all)
    bufmap('n', '<leader>lvo', set_virtual_text_off)
    bufmap('n', '<leader>lve', set_virtual_text_error)
    bufmap('n', '<leader>lva', set_virtual_text_all)
    bufmap('n', '<leader>f', format)
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = mappings
})
