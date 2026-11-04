-- Completion options ---------------------------------------------------------

-- Request completion with Ctrl-Space instead of on each keystroke.
vim.opt.autocomplete = false
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

-- Refresh command suggestions only after an explicit completion request.
local command_completion_active = false
vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = completion_group,
    pattern = ":",
    callback = function()
        if command_completion_active then
            vim.fn.wildtrigger()
        end
    end,
})
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = completion_group,
    callback = function()
        command_completion_active = false
    end,
})

local function enable_lsp_completion(client, bufnr)
    if client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
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

local function completion_visible(mode)
    return (mode == "i" and vim.fn.pumvisible() == 1)
        or (mode == "c" and vim.fn.wildmenumode() == 1)
end

for _, mode in ipairs({ "i", "c" }) do
    local function navigation(key, fallback)
        return function()
            return completion_visible(mode) and key or fallback
        end
    end

    vim.keymap.set(mode, "<Up>", navigation("<C-p>", "<Up>"), { expr = true, desc = "Previous suggestion" })
    vim.keymap.set(mode, "<Down>", navigation("<C-n>", "<Down>"), { expr = true, desc = "Next suggestion" })
    vim.keymap.set(mode, "<Tab>", navigation("<C-n>", "<Tab>"), { expr = true, desc = "Next suggestion" })
    vim.keymap.set(mode, "<S-Tab>", navigation("<C-p>", "<S-Tab>"), { expr = true, desc = "Previous suggestion" })
    vim.keymap.set(mode, "<C-Space>", function()
        if completion_visible(mode) then
            if mode == "c" then
                command_completion_active = false
            end
            return "<C-e>"
        end
        if mode == "c" then
            command_completion_active = true
        end
        return mode == "i" and "<C-n>" or "<C-z>"
    end, { expr = true, desc = "Toggle completion" })
    vim.keymap.set(mode, "<C-y>", function()
        if mode == "c" then
            command_completion_active = false
        end
        if completion_visible(mode) then
            local selected = mode == "i" and vim.fn.complete_info({ "selected" }).selected
                or vim.fn.cmdcomplete_info().selected
            if selected == -1 then
                return "<C-n><C-y>"
            end
        end
        return "<C-y>"
    end, { expr = true, desc = "Accept selected or first suggestion" })
end

vim.keymap.set("c", "<C-e>", function()
    command_completion_active = false
    return "<C-e>"
end, { expr = true, desc = "Cancel completion" })

-- Keep Enter and Escape native.
vim.keymap.set("n", "<C-Space>", "a<C-n>", { desc = "Insert after cursor and request completion" })
