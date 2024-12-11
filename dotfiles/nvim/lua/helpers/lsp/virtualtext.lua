---@class VirtualText
---@field off function
---@field error function
---@field all function
local M = {}

function M.off()
    vim.diagnostic.config({ virtual_text = false })
end

function M.error()
    vim.diagnostic.config({
        virtual_text = { severity = vim.diagnostic.severity.ERROR }
    })
end

function M.all()
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

return M
