---@class CapabilityHelpers
---@field has_action fun(client: vim.lsp.Client, action: string): boolean
local M = {}

---Check if the client has the action
---@param client vim.lsp.Client
---@param action string
---@return boolean has_action true if the client has the action
function M.has_action(client, action)
    local ok, actions = pcall(function()
        return client.server_capabilities.codeActionProvider.codeActionKinds
    end)
    return ok and type(actions) == "table" and vim.tbl_contains(actions, action)
end



-- local has_organize_imports = has_action(client, "source.organizeImports")
-- local organize_imports_is_nil = buf_table.organize_imports == nil
-- if has_organize_imports and organize_imports_is_nil then
--     vim.notify("Organize imports -> " .. client.name)
--     buf_table.organize_imports = function()
--         vim.lsp.buf.code_action({
--             context = { only = { "source.organizeImports" } },
--             apply = true,
--         })
--     end
-- elseif has_organize_imports and not organize_imports_is_nil then            
--     vim.notify("Organize imports is supported by multiple clients", vim.log.levels.ERROR)
-- end
--
-- local has_format = has_action(client, "source.format")
-- local format_is_nil = buf_table.format == nil
-- if has_format and format_is_nil then
--     vim.notify("Formatting -> " .. client.name)
--     buf_table.format = function()
--         vim.lsp.buf.formatting()
--     end
-- elseif has_format and not format_is_nil then
--     error("Format is supported by multiple clients")
-- end
