local null_ls = require("null-ls")

---@class NullLsNotify
---@field attach function(buf: integer)
local M = {}

function M.attach(buf)
    local attached = null_ls.get_sources()
    local ft = vim.bo[buf].filetype
    for _, source in pairs(attached) do
        if source.filetypes[ft] then
            require("helpers.lsp.notify").attach(source, buf)
        end
    end
end

return M
