---@class Formatting
---@field has_action function
---@field make_organize_imports function
---@field make function
local M = {}

---Check if the client has the action
---@param client table
---@param action string
---@return boolean has_action true if the client has the action
function M.has_action(client, action)
    local ok, actions = pcall(function()
        return client.server_capabilities.codeActionProvider.codeActionKinds
    end)
    return ok and type(actions) == "table" and vim.tbl_contains(actions, action)
end

---Return a function that organizes imports through code actions
---@param client table
---@return function organize_imports function that organizes imports if the
---client supports it if not it returns an empty function
function M.make_organize_imports(client)
    if M.has_action(client, "source.organizeImports") then
        vim.notify("Use LSP to organize imports", vim.log.levels.INFO)
        return function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                apply = true,
            })
        end
    else
        return function() end
    end
end

function M.make(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local organize_imports = M.make_organize_imports(client)
    return function()
        vim.lsp.buf.format({ async = true })
        organize_imports()
    end
end

return M
