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

local ID = "lsp_underline"
local index = 0
local opts = { M.off, M.error, M.all }
local names = { "off", "error", "all" }
function M.rotate()
    index = (index % #opts) + 1
    opts[index]()
    vim.notify(
        string.format("Diagnostics underline: %s", names[index]),
        vim.log.levels.INFO,
        { title = "Underline", id = ID }
    )
end

return M
