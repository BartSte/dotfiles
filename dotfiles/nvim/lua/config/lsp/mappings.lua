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

    bufmap('n', '<space>f', format)
    bufmap('n', '<C-s>', vim.lsp.buf.signature_help) -- Matches insert mode map
    bufmap('n', '<C-k>', vim.lsp.buf.hover)          -- Alternative for K

    bufmap('n', '<space>luo', set_underline_off)
    bufmap('n', '<space>lue', set_underline_error)
    bufmap('n', '<space>lua', set_underline_all)
    bufmap('n', '<space>lvo', set_virtual_text_off)
    bufmap('n', '<space>lve', set_virtual_text_error)
    bufmap('n', '<space>lva', set_virtual_text_all)
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = mappings
})
