local m = require("helpers.keymapper")
local helpers = require("helpers.lsp")

---@class MappingsLsp
---@field setup function Set up this module
---@field set_mappings function Set up mappings for LSP
---@field initial_capabilities table Capabilities that only one client should provide
---@field mapping_capablilties table Capabilities that are required for all the mappings to work
---@field mapping_actions table Actions that are required for all the mappings to work
local M = {}

M.mapping_capablilties = {
    "documentFormattingProvider",
    "documentRangeFormattingProvider"
}

M.mapping_actions = {
    "source.organizeImports"
}

---@class LspAttachArgs
---@field buf number
---@field data table {client_id: number}
---@field event string
---@field file string
---@field id number
---@field match string

--- Set up mappings for LSP
---@param args LspAttachArgs Arguments passed by LSP attach
function M.setup(args)
    M.set_mappings()
    M.check_capabilities(args)
end

local function organize_imports()
    vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
    })
end

function M.set_mappings()
    m.buffer_nnoremap("<C-k>", vim.lsp.buf.hover)
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<leader>f", vim.lsp.buf.format)
    m.buffer_nnoremap("<leader>i", organize_imports)
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

--- Nofify if multiple clients are attached that overlap in one of the
--- capabilities that are provided by `capabilities`.
--- - documentRangeFormattingProvider
--- @param args LspAttachArgs Arguments passed by LSP attach
function M.check_capabilities(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
        vim.notify("Client not found", vim.log.levels.ERROR)
        return
    end

    helpers.capabilities.buffer.update_capabilities(client, args.buf, M.mapping_capablilties)
    helpers.capabilities.buffer.update_actions(client, args.buf, M.mapping_actions)
    helpers.capabilities.buffer.notify(args.buf)
end

return M
