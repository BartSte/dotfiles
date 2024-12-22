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

    -- TODO: refactor!
    if not vim.b[args.buf].msg then
        vim.b[args.buf].msg = ""
    end
    if not vim.b[args.buf].msg_id then
        vim.b[args.buf].msg_id = nil
    end
    local buf_capabilities = vim.b[args.buf].capabilities or {}
    for _, capability in ipairs(M.mapping_capablilties) do
        if client.server_capabilities[capability] then
            if not buf_capabilities[capability] then
                buf_capabilities[capability] = client.name
                vim.b[args.buf].msg = vim.b[args.buf].msg .. "\n" .. capability .. " -> " .. client.name
                vim.b[args.buf].msg_id = Snacks.notify.info(
                    vim.b[args.buf].msg,
                    {
                        title = "LSP Capabilities",
                        id = vim.b[args.buf].msg_id
                    }
                )
            elseif buf_capabilities[capability] ~= client.name then
                vim.notify("Multiple clients provide " .. capability, vim.log.levels.ERROR)
            end
        end
    end
    vim.b[args.buf].capabilities = buf_capabilities

    -- local buf_actions = get_buf_actions(args)
    -- local client_actions = client.server_capabilities.codeActionProvider.codeActionKinds or {}
    -- ---Do one of the following things for the code actions:
    -- ---Get the actions that are present in both the buf_actions and the client_actions
    -- ---If the resulting actions are also present in the mapping_actions, log an error
    -- ---Finally, extend the buf_actions with the client_actions without duplicates
    -- local overlap_with_client = vim.tbl_filter(function(action)
    --     return vim.tbl_contains(client_actions, action)
    -- end, buf_actions)
    -- local overlap_with_mapping = vim.tbl_filter(function(action)
    --     return vim.tbl_contains(M.mapping_actions, action)
    -- end, overlap_with_client)
    -- if #overlap_with_mapping > 0 then
    --     vim.notify("Multiple clients provide " .. table.concat(overlap_with_mapping, ", "), vim.log.levels.ERROR)
    -- end
    -- vim.list_extend(buf_actions, client_actions)
    -- dd(buf_actions)
end

return M
