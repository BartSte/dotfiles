local m = require("helpers.keymapper")
local fn = require("helpers.fn")
local helpers = require("helpers.lsp.capabilities")

---@class LspMappings
---@field map_formatter function(client: vim.lsp.Client, buf: integer): function
local M = {}
local IGNORE = { "GitHub Copilot" }
local formatters = {}
local actions = {}


--- Run a formatter on the current buffer.
---@return function formatter The formatter function
local function make_buf_format()
    return function()
        vim.lsp.buf.format({ timeout_ms = 5000, async = false })
    end
end

--- Run code actions on the current buffer.
---@param client vim.lsp.Client The client to use for the actions
local function make_run_actions(client)
    return function()
        vim.lsp.buf.code_action({
            context = {
                only = client.server_capabilities.format_actions,
                diagnostics = {}
            },
            apply = true,
        })
    end
end

--- Map a formatter function to a keybinding that is also able to run code
--- actions alongside the formatter.
---@param client vim.lsp.Client The client to use for the formatter
---@param buf integer The buffer to apply the formatter to
---@param lhs string The keybinding to map to the formatter
---@return function formatter The formatter function
function M.map_formatter(client, buf, lhs)
    local formatter = M.make_formatter(client, buf)
    if formatter then
        m.buffer_nnoremap(lhs or "<space>f", formatter)
    end
end

--- Create a formatter function that can run code actions alongside the formatter.
---@param client vim.lsp.Client? The client to use for the formatter
---@param buf integer? The buffer to apply the formatter to
---@return function|nil formatter The formatter function
function M.make_formatter(client, buf)
    buf = buf or vim.api.nvim_get_current_buf()
    local client_name = client and client.name or "Unknown"

    if vim.tbl_contains(IGNORE, client_name) then
        return nil
    end

    if helpers.has_capability(client, "documentFormattingProvider") then
        formatters[buf] = fn.decorate({ formatters[buf], make_buf_format() })
    end

    -- `format_actions` is a custom capability that is not part of the LSP spec
    if client and helpers.has_capability(client, "format_actions") then
        actions[buf] = fn.decorate({ actions[buf], make_run_actions(client) })
    end

    if not formatters[buf] and not actions[buf] then
        return M.gggqEq
    else
        return fn.decorate({ formatters[buf], actions[buf] })
    end
end

--- Run gggqG and then return to the cursor before the command was run.
function M.gggqEq()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! gggq=")
    vim.api.nvim_win_set_cursor(0, pos)
end

return M
