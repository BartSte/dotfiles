local treesitter = require("nvim-treesitter")

treesitter.setup()

local function configure_folds(bufnr)
    local winid = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(winid) ~= bufnr then
        return
    end

    if vim.wo[winid].diff then
        vim.schedule(function()
            if not vim.api.nvim_win_is_valid(winid) or not vim.wo[winid].diff then
                return
            end

            vim.api.nvim_win_call(winid, function()
                vim.cmd("silent! normal! zR")
            end)
            vim.w[winid].folds_disabled_for_diff = true
            vim.wo[winid].foldenable = false
            vim.wo[winid].foldlevel = 99
        end)
        return
    end

    if vim.w[winid].folds_disabled_for_diff then
        vim.w[winid].folds_disabled_for_diff = nil
        vim.wo[winid].foldenable = true
    end

    if vim.b[bufnr].treesitter_folds then
        vim.wo[winid].foldmethod = "expr"
        vim.wo[winid].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
        vim.wo[winid].foldmethod = "indent"
        vim.wo[winid].foldexpr = "0"
    end
end

local group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(ev)
        local filetype = vim.bo[ev.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype) or filetype
        local ok, loaded = pcall(vim.treesitter.language.add, lang)

        local started = ok and loaded and pcall(vim.treesitter.start, ev.buf, lang)

        if started then
            local query_ok, folds = pcall(vim.treesitter.query.get, lang, "folds")
            vim.b[ev.buf].treesitter_folds = query_ok and folds ~= nil
        else
            vim.b[ev.buf].treesitter_folds = false
            vim.bo[ev.buf].syntax = filetype
        end

        configure_folds(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(ev)
        configure_folds(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "diff",
    callback = function()
        configure_folds(vim.api.nvim_get_current_buf())
    end,
})
