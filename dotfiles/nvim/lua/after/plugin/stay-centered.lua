local skip_filetypes = {
    bigfile = true,
    floggraph = true,
    fzf = true,
    help = true,
    lazy = true,
    mason = true,
    oil = true,
    qf = true,
}

local group = vim.api.nvim_create_augroup('StayCentered', { clear = true })

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufEnter', 'WinEnter' }, {
    group = group,
    callback = function()
        if vim.bo.buftype ~= '' or skip_filetypes[vim.bo.filetype] then
            return
        end

        local buffer = vim.api.nvim_get_current_buf()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local previous = vim.w.centered_cursor
        vim.w.centered_cursor = { buffer = buffer, line = line }
        if not previous or previous.buffer ~= buffer or previous.line == line then
            return
        end

        local view = vim.fn.winsaveview()
        vim.cmd.normal({ 'zz', bang = true })
        -- Restore cursor details without restoring the old scroll position.
        vim.fn.winrestview({
            lnum = view.lnum,
            col = view.col,
            coladd = view.coladd,
            curswant = view.curswant,
        })
    end,
})
