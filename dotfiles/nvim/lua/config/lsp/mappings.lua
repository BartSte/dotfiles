local m = require("helpers.keymapper")

---@class MappingsLsp
---@field on_lsp_attach fun(client: vim.lsp.Client, buf: integer): nil Set up mappings that apply to all LSP servers
local M = {}

---@param client vim.lsp.Client
---@param language string
---@param spelllang string
---@return nil
local function set_ltex_language(client, language, spelllang)
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { spelllang }

    local settings = type(client.config.settings) == "table" and client.config.settings or {}
    client.config.settings = settings
    ---@type table
    local ltex = {}
    local existing_ltex = rawget(settings, "ltex")
    if type(existing_ltex) == "table" then
        ltex = existing_ltex
    end
    settings.ltex = vim.tbl_deep_extend("force", ltex, {
        language = language,
    })
    client:notify("workspace/didChangeConfiguration", { settings = settings })
    vim.notify("LTeX language: " .. language)
end

--- Set up mappings that apply to all LSP servers
---@param client vim.lsp.Client
---@param buf integer
---@return nil
function M.on_lsp_attach(client, buf)
    local helpers = require("helpers.lsp")
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtualtext.all)
    m.buffer_nnoremap("<space>lve", helpers.virtualtext.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtualtext.off)
    m.buffer_nnoremap("gra", vim.lsp.buf.code_action)
    m.buffer_nnoremap("grn", vim.lsp.buf.rename)
    m.buffer_nnoremap("grr", vim.lsp.buf.references)
    m.buffer_nnoremap("<C-]>", vim.lsp.buf.definition)
    helpers.mappings.map_formatter(client, buf)

    if client.name == "ltex_plus" then
        m.silent_buffer_nnoremap("<leader>le", function()
            set_ltex_language(client, "en-US", "en")
        end)
        m.silent_buffer_nnoremap("<leader>ln", function()
            set_ltex_language(client, "nl", "nl")
        end)
    end
end

return M
