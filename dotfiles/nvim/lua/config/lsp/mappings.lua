local m = require("helpers.keymapper")

---@class MappingsLsp
---@field on_lsp_attach function Set up mappings that apply to all LSP servers
local M = {}

local function set_ltex_language(client, language, spelllang)
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { spelllang }

    client.config.settings = client.config.settings or {}
    client.config.settings.ltex = vim.tbl_deep_extend("force", client.config.settings.ltex or {}, {
        language = language,
    })
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    vim.notify("LTeX language: " .. language)
end

--- Set up mappings that apply to all LSP servers
function M.on_lsp_attach(client, buf)
    local helpers = require("helpers.lsp")
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtualtext.all)
    m.buffer_nnoremap("<space>lve", helpers.virtualtext.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtualtext.off)
    m.buffer_nnoremap("l", helpers.underline.rotate)
    m.buffer_nnoremap("j", helpers.virtualtext.rotate)
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
