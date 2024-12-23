local m = require("helpers.keymapper")
local helpers = require("helpers.lsp")

---@class LspAttachArgs
---@field buf number
---@field data table {client_id: number}
---@field event string
---@field file string
---@field id number
---@field match string

---@class MappingsLsp
---@field setup function Set up this module
---@field set_mappings function Set up mappings for LSP
---@field update_capabilities function Update capabilities for LSP
local M = {}

local capabilities = {
    formatting = {
        "documentFormattingProvider",
        "documentRangeFormattingProvider"
    },
    organize_imports = {
        "source.organizeImports.ruff"
    }
}

--- Set up this module
---@param args LspAttachArgs Arguments passed by LSP attach
function M.setup(args)
    M.update_capabilities(args)
    M.set_mappings(args)
end

--- Update capabilities for LSP
---@param args LspAttachArgs Arguments passed by LSP attach
function M.update_capabilities(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
        vim.notify("Client not found", vim.log.levels.ERROR)
        return
    end
    helpers.capabilities.update_formatting(args.buf, client, capabilities.formatting)
    helpers.capabilities.update_organize_imports(args.buf, client, capabilities.organize_imports)
    helpers.capabilities.notify(args.buf)
end

--- Create a function that organizes imports
---@param args LspAttachArgs Arguments passed by LSP attach
---@return function Function that organizes imports
local function make_organize_imports(args)
    local kinds = helpers.capabilities.get_organize_import_kinds(args.buf)
    return function()
        vim.lsp.buf.code_action({
            context = {
                only = kinds,
                diagnostics = {}
            },
            apply = true,
        })
    end
end

function M.set_mappings(args)
    m.buffer_nnoremap("<C-k>", vim.lsp.buf.hover)
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<leader>f", vim.lsp.buf.format)
    m.buffer_nnoremap("<leader>i", make_organize_imports(args))
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtualtext.all)
    m.buffer_nnoremap("<space>lve", helpers.virtualtext.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtualtext.off)
    m.buffer_nnoremap("gra", vim.lsp.buf.code_action)
    m.buffer_nnoremap("grn", vim.lsp.buf.rename)
    m.buffer_nnoremap("grr", vim.lsp.buf.references)
end

return M
