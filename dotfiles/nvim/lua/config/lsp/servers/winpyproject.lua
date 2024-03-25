-- Not recommended to use this, but it works.
local function on_attach(client, bufnr)
    if client.name == 'ruff_lsp' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end
end

-- Example of the recommended ensure only null-ls is used for formatting
-- local lsp_formatting = function(bufnr)
--     vim.lsp.buf.format({
--         filter = function(client)
--             return client.name == "null-ls"
--         end,
--         bufnr = bufnr,
--     })
-- end

-- -- if you want to set up formatting on save, you can use this as a callback
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- -- add to your shared on_attach callback
-- local on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--         vim.api.nvim_create_autocmd("BufWritePre", {
--             group = augroup,
--             buffer = bufnr,
--             callback = function()
--                 lsp_formatting(bufnr)
--             end,

--         })
--     end
-- end

require('lspconfig').ruff_lsp.setup({
    on_attach = on_attach
})
