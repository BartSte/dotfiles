---@class HelpersLsp
---@field underline Underline
---@field virtual_text VirtualText
---@field format function
local M = {}

---@class Underline
---@field off function
---@field error function
---@field all function
M.underline = {}

function M.underline.off()
    vim.diagnostic.config({ underline = false })
end

function M.underline.error()
    vim.diagnostic.config({
        underline = { severity = vim.diagnostic.severity.ERROR }
    })
end

function M.underline.all()
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

---@class VirtualText
---@field off function
---@field error function
---@field all function
M.virtual_text = {}

function M.virtual_text.off()
    vim.diagnostic.config({ virtual_text = false })
end

function M.virtual_text.error()
    vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR } })
end

function M.virtual_text.all()
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

---Format the current buffer.
---This includes organizing imports for some languages as is defined in the
---`config.lsp.filters.code_action` function.
---@return nil
function M.format()
    if require("projectrc").require("config.lsp.filters").code_action() then
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" }, diagnostics = {} },
            apply = true,
        })
    end

    vim.lsp.buf.format({
        filter = require("projectrc").require("config.lsp.filters").format,
        timeout_ms = 5000,
        async = false
    })
end

return M
