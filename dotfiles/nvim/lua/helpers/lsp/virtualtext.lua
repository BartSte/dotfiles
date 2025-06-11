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

local ID = "lsp_virtual_text"
local index = 0
local opts = { M.off, M.error, M.all }
local names = { "off", "error", "all" }
function M.rotate()
    index = (index % #opts) + 1
    opts[index]()
    vim.notify(
        string.format("Diagnostics text: %s", names[index]),
        vim.log.levels.INFO,
        { title = "Virtual text", id = ID }
    )
end

return M
