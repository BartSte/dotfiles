local opts = require("helpers.opts")

---@class BufferCapabilities
---Capabilities that are related to a buffer
---@field formatting FormattingCapabilities Capabilities that are
---related to formatting
---@field organize_imports OrganizeImportsCapabilities Capabilities
---that are related to organizing imports

---@class FormattingCapabilities
---List the formatting capabilities that the client has. The fields of this table
---do not need to configured as `documentFormattingProvider` and
---`documentRangeFormattingProvider` are the only fields that are relevant for
---formatting.
---@field documentFormattingProvider table? The table will contain the name of
---the client that has the capability for a specific buffer.
---@field documentRangeFormattingProvider table? The table will contain the name
---of the client that has the capability for a specific buffer.

---@class OrganizeImportsCapabilities
---List the code action kinds that the client has for organizing imports. The
---fields of this table needs to be configured with the code action kinds that
---the users want to use for organizing imports.
---The keys of this table are the names of code action kinds and their values are
---should be a table that is later filled with the names of the clients that have
---the code action kind.
---For example:
---```lua
---M.organize_imports = {
---    ["source.organizeImports.ruff"] = {}
--- }
---```

---@class CapabilityHelpers
---Capabilities that are related to a buffer organizing imports
---@field get_capabilities fun(buf: number): BufferCapabilities
---@field update_formatting fun(buf: number, client: vim.lsp.Client, capabilities: table): 
---@field update_organize_imports fun(buf: number, client: vim.lsp.Client, capabilities: table): 
---@field has_action fun(client: vim.lsp.Client, action: string): boolean
---@field notify fun(buf: number): integer
local M = {}

--- Get buffer capabilities
---@param buf number The buffer number
---@return BufferCapabilities capabilities The buffer capabilities
function M.get_capabilities(buf)
    if vim.b[buf].capabilities == nil then
        vim.b[buf].capabilities = { formatting = {}, organize_imports = {} }
    end
    return vim.b[buf].capabilities
end

--- Get formatting capabilities
---@param buf number The buffer number
---@return string[] capabilities The formatting capabilities
function M.get_formatting_capabilities(buf)
    local capabilities = M.get_capabilities(buf)
    return vim.tbl_keys(capabilities.formatting)
end

--- Get code action kinds
---@param buf number The buffer number
---@return string[] codeActionKinds code action kinds
function M.get_organize_import_kinds(buf)
    local capabilities = M.get_capabilities(buf)
    return vim.tbl_keys(capabilities.organize_imports)
end

--- Update buffer capabilities
--- This function will update the `vim.b[buf].capabilities` table with the
--- capabilities that the client has. It will only update the capabilities that
--- are in the `capabilities` list.
---@param buf number The buffer number
---@param client vim.lsp.Client The client that is attached to the buffer
---@param capabilities string[] A list of capabilities tot consider
function M.update_formatting(buf, client, capabilities)
    local tmp = M.get_capabilities(buf)
    for _, value in ipairs(capabilities) do
        if client.server_capabilities[value] then
            tmp.formatting[value] = opts.list_extend_no_duplicates(
                tmp.formatting[value] or {},
                { client.name }
            )
        end
    end
    vim.b[buf].capabilities = tmp
end

--- Update the code actions
---@param buf number The buffer number
---@param client vim.lsp.Client The client that is attached to the buffer
---@param code_action_kinds string[] The actions to consider
function M.update_organize_imports(buf, client, code_action_kinds)
    local tmp = M.get_capabilities(buf)
    for _, value in ipairs(code_action_kinds) do
        if M.has_action(client, value) then
            tmp.organize_imports[value] = opts.list_extend_no_duplicates(
                tmp.organize_imports[value] or {},
                { client.name }
            )
        end
    end
    vim.b[buf].capabilities = tmp
end

---Check if the client has the action
---@param client vim.lsp.Client The client that is attached to the buffer
---@param action string The action that the client should have
---@return boolean has_action true if the client has the action
function M.has_action(client, action)
    local ok, actions = pcall(function()
        return client.server_capabilities.codeActionProvider.codeActionKinds
    end)
    return ok and type(actions) == "table" and vim.tbl_contains(actions, action)
end

--- Notify the buffer capabilities
---@param buf number The buffer number
---@return integer id The notification id
function M.notify(buf)
    msg_ids.buffer_capabilities = Snacks.notify.info(
        vim.inspect(M.get_capabilities(buf)), {
            title = "LSP capabilities",
            id = msg_ids.buffer_capabilities
        }
    )
    return msg_ids.buffer_capabilities
end

return M
