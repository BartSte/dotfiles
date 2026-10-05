-- Completion options ---------------------------------------------------------

vim.opt.autocomplete = true
vim.opt.complete = { "o^30", ".^20", "F^20" }
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
vim.opt.pumborder = "rounded"
vim.opt.pummaxwidth = 80

vim.opt.wildmenu = true
vim.opt.wildmode = { "noselect:lastused", "full" }
vim.opt.wildoptions = { "pum", "fuzzy" }

-- Path completion ------------------------------------------------------------

local path_completion_active = false

local function path_complete(findstart, base)
    if findstart == 1 then
        local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
        local text_before_cursor = vim.api.nvim_get_current_line():sub(1, cursor_col)
        local path_fragment = text_before_cursor:match([[([^%s"'`]+)$]]) or ""

        path_completion_active = path_fragment:find("/", 1, true) ~= nil
            or path_fragment:find("\\", 1, true) ~= nil
        return path_completion_active and cursor_col - #path_fragment or cursor_col
    end

    if not path_completion_active then
        return {}
    end

    return vim.tbl_map(function(path)
        return {
            word = path,
            abbr = vim.fn.strcharpart(path, 0, 50),
            kind = "File",
            menu = "PATH",
        }
    end, vim.fn.getcompletion(base, "file"))
end

_G.NativePathComplete = path_complete
vim.opt.completefunc = "v:lua.NativePathComplete"

-- LSP completion -------------------------------------------------------------

local completion_group = vim.api.nvim_create_augroup("native_completion", { clear = true })

local function enable_lsp_completion(client, bufnr)
    if client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, bufnr)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = completion_group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
            enable_lsp_completion(client, event.buf)
        end
    end,
})

for _, client in ipairs(vim.lsp.get_clients({ method = "textDocument/completion" })) do
    for bufnr in pairs(client.attached_buffers) do
        enable_lsp_completion(client, bufnr)
    end
end

-- Large files ----------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
    group = completion_group,
    pattern = "bigfile",
    callback = function(event)
        vim.bo[event.buf].autocomplete = false
    end,
})

-- Mappings -------------------------------------------------------------------

local function wildmenu_navigation(key, fallback)
    return function()
        return vim.fn.wildmenumode() == 1 and key or fallback
    end
end

vim.keymap.set("c", "<Up>", wildmenu_navigation("<C-p>", "<Up>"), { expr = true })
vim.keymap.set("c", "<Down>", wildmenu_navigation("<C-n>", "<Down>"), { expr = true })

local function completion_navigation(key, fallback)
    return function()
        return vim.fn.pumvisible() == 1 and key or fallback
    end
end

vim.keymap.set("i", "<Up>", completion_navigation("<C-p>", "<Up>"), { expr = true })
vim.keymap.set("i", "<Down>", completion_navigation("<C-n>", "<Down>"), { expr = true })
vim.keymap.set("i", "<C-Space>", "<C-n>", { desc = "Trigger completion" })
vim.keymap.set("i", "<C-y>", function()
    local selected = vim.fn.complete_info({ "selected" }).selected

    if vim.fn.pumvisible() == 1 and selected == -1 then
        return "<C-n><C-y>"
    end

    return "<C-y>"
end, { desc = "Accept first completion item", expr = true })
