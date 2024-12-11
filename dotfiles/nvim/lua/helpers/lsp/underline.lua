---@class Underline
---@field off function
---@field error function
---@field all function
local M = {}

M.underline = {}

function M.off()
    vim.diagnostic.config({ underline = false })
end

function M.error()
    vim.diagnostic.config({
        underline = { severity = vim.diagnostic.severity.ERROR }
    })
end

function M.all()
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

return M
