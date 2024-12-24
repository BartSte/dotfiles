---@class Notify
--- A list of clients that have been attached to a buffer of a specific filetype
---@field get_attached_once function(buf: integer): string[]
--- Check if a client has been attached to a buffer of a specific filetype
---@field is_attached_once function(buf: integer, client: string): boolean
--- Update the list of clients that have been attached to a buffer of a specific
--- filetype
---@field update_attached_once function(buf: integer, client: string): void
local M = {}
local attached_once = {}

--- Return the list of clients that have been attached to a buffer of a specific
--- filetype at least once
---@param buf integer
---@return string[] A list of client names
M.get_attached_once = function(buf)
    local ft = vim.bo[buf].filetype
    if not attached_once[ft] then
        attached_once[ft] = {}
    end
    return attached_once[ft]
end

--- Update the list of clients that have been attached to a buffer of a specific
--- filetype
---@param client vim.lsp.Client
---@param buf integer
M.update_attached_once = function(client, buf)
    table.insert(M.get_attached_once(buf), client.name)
end

--- Check if a client has been attached to a buffer of a specific filetype
---@param client vim.lsp.Client
---@param buf integer
---@return boolean
M.is_attached_once = function(client, buf)
    return vim.tbl_contains(M.get_attached_once(buf), client.name)
end

return M
