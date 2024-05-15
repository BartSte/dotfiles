local M = {}

--- Returns a callback that checks if the client name is the same as the one passed
--- in the argument
---@param client_name string The name of the client to check
---@return function callback A function that takes a client and returns a
---boolean
local function is_client_callback(client_name)
    return function(client)
        return client.name == client_name
    end
end

--- Returns a callback that formats the buffer using the client with the name
--- passed in the argument
---@param client_name string The name of the client to use for formatting
---@return function callback A function that takes a buffer number and formats it
local function format_callback(client_name)
    return function(bufnr)
        vim.lsp.buf.format({
            filter = is_client_callback(client_name),
            bufnr = bufnr
        })
    end
end

--- Returns a callback that creates a formatting function that formats current
--- buffer using the client with the name passed in the argument. Next, this
--- formatter is mapped to `mapping` in normal mode. You cann attach the returned
--- callback to the `on_attach` option of an LSP client.
---@param name string The name of the client to use for formatting
---@param mapping string The mapping to use for formatting
---@return function callback A function that takes a client name and a mapping
---and returns a function that formats the buffer and maps it to the mapping
---passed in the argument
M.format_with_client = function(name, mapping)
    local format = format_callback(name)
    return function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            require("helpers.keymapper").buffer_nnoremap(
                mapping,
                function() format(bufnr) end
            )
        end
    end
end

return M
