---@class Underline
---@field off fun(): nil
---@field error fun(): nil
---@field all fun(): nil
---@field toggle fun(): nil
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
function M.toggle()
    if vim.diagnostic.config().underline == false then
        M.all()
        vim.notify("Diagnostics underline: all", vim.log.levels.INFO, { title = "Underline", id = ID })
        return
    end

    M.off()
    vim.notify(
        "Diagnostics underline: off",
        vim.log.levels.INFO,
        { title = "Underline", id = ID }
    )
end

return M
