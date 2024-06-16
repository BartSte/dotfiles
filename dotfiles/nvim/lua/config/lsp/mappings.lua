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
    if vim.bo.filetype == 'org' then
        return
    end

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

    bufmap('n', '<a-k>', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>wincmd v<cr><cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', '<leader>p', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('i', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<leader>uo', set_underline_off)
    bufmap('n', '<leader>ue', set_underline_error)
    bufmap('n', '<leader>ua', set_underline_all)
    bufmap('n', '<leader>vo', set_virtual_text_off)
    bufmap('n', '<leader>ve', set_virtual_text_error)
    bufmap('n', '<leader>va', set_virtual_text_all)
    bufmap('n', '<leader>f', format)
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = mappings
})
