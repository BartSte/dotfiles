---@class VirtualText
---@field off fun(): nil
---@field error fun(): nil
---@field all fun(): nil
---@field toggle fun(): nil
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

local ID = "lsp_virtual_text"
function M.toggle()
    if vim.diagnostic.config().virtual_text == false then
        M.all()
        vim.notify("Diagnostics text: all", vim.log.levels.INFO, { title = "Virtual text", id = ID })
        return
    end

    M.off()
    vim.notify(
        "Diagnostics text: off",
        vim.log.levels.INFO,
        { title = "Virtual text", id = ID }
    )
end

return M
