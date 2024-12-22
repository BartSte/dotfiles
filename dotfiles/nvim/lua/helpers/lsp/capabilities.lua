local opts = require("helpers.opts")

---@class CapabilityHelpers
---@field has_action fun(client: vim.lsp.Client, action: string): boolean
---@field buffer BufferCapabilityHelpers
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

---@class BufferCapabilityHelpers
---@field get_capabilities fun(buf: number): table
---@field update_capabilities fun(client: vim.lsp.Client, buf: number, capabilities: table): table
---@field notify fun(buf: number): integer
M.buffer = {

    --- Get buffer capabilities
    ---@param buf number The buffer number
    ---@return table capabilities The buffer capabilities
    get_capabilities = function(buf)
        if vim.b[buf].capabilities == nil then
            vim.b[buf].capabilities = { actions = {} }
        end
        return vim.b[buf].capabilities
    end,

    --- Update buffer capabilities
    --- This function will update the `vim.b[buf].capabilities` table with the
    --- capabilities that the client has. It will only update the capabilities that
    --- are in the `capabilities` list.
    ---@param client vim.lsp.Client The client that is attached to the buffer
    ---@param buf number The buffer number
    ---@param capabilities table The capabilities to consider
    ---@return table capabilities The updated buffer capabilities
    update_capabilities = function(client, buf, capabilities)
        local buffer_capabilities = M.buffer.get_capabilities(buf)
        for _, value in ipairs(capabilities) do
            if client.server_capabilities[value] then
                dd(client.name .. " -> " .. value .. " -> " .. vim.inspect(client.server_capabilities[value]))
                buffer_capabilities[value] = opts.list_extend_no_duplicates(
                    buffer_capabilities[value] or {},
                    { client.name }
                )
            end
        end
        vim.b[buf].capabilities = buffer_capabilities
        return vim.b[buf].capabilities
    end,

    --- Update the code actions
    ---@param client vim.lsp.Client The client that is attached to the buffer
    ---@param buf number The buffer number
    ---@param actions table The actions to consider
    ---@return table capabilities The updated buffer capabilities
    update_actions = function(client, buf, actions)
        local buffer_capabilities = vim.b[buf].capabilities
        for _, value in ipairs(actions) do
            if M.has_action(client, value) then
                buffer_capabilities.actions[value] = opts.list_extend_no_duplicates(
                    buffer_capabilities.actions[value] or {},
                    { client.name }
                )
            end
        end
        vim.b[buf].capabilities = buffer_capabilities
        return vim.b[buf].capabilities
    end,

    --- Notify the buffer capabilities
    ---@param buf number The buffer number
    ---@return integer|nil id The notification id
    notify = function(buf)
        local buffer_capabilities = M.buffer.get_capabilities(buf)
        vim.b[buf].msg_id_capabilities = Snacks.notify.info(
            vim.inspect(buffer_capabilities), {
                title = "LSP capabilities",
                id = vim.b[buf].msg_id_capabilities
            }
        )
        return vim.b[buf].msg_id_capabilities
    end

}

return M
