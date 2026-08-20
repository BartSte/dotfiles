local enabled = true
local delay_ms = 2000
local timers = {}

local function buffer_auto_save_enabled(bufnr)
    local winid = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(winid) == bufnr and vim.w[winid].auto_save ~= nil then
        return vim.w[winid].auto_save ~= 0
    end
    if vim.b[bufnr].auto_save ~= nil then
        return vim.b[bufnr].auto_save ~= 0
    end
    return enabled
end

local function save_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        return
    end

    if not buffer_auto_save_enabled(bufnr)
        or not vim.bo[bufnr].modified
        or not vim.bo[bufnr].modifiable
        or vim.bo[bufnr].buftype ~= ""
        or vim.api.nvim_buf_get_name(bufnr) == ""
    then
        return
    end

    vim.api.nvim_buf_call(bufnr, function()
        local first_changed = vim.fn.getpos("'[")
        local last_changed = vim.fn.getpos("']")
        local view = vim.fn.winsaveview()

        vim.cmd("silent! update")

        vim.fn.winrestview(view)
        vim.fn.setpos("'[", first_changed)
        vim.fn.setpos("']", last_changed)
    end)
end

local function schedule_save(bufnr)
    local timer = timers[bufnr]
    if not timer then
        timer = vim.uv.new_timer()
        timer:unref()
        timers[bufnr] = timer
    end

    timer:stop()
    timer:start(delay_ms, 0, vim.schedule_wrap(function()
        save_buffer(bufnr)
    end))
end

local group = vim.api.nvim_create_augroup("auto_save", { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    callback = function(ev)
        schedule_save(ev.buf)
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimSuspend" }, {
    group = group,
    callback = function(ev)
        save_buffer(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
        local timer = timers[ev.buf]
        if timer then
            timer:stop()
            timer:close()
            timers[ev.buf] = nil
        end
    end,
})

vim.api.nvim_create_user_command("AutoSaveToggle", function()
    enabled = not enabled
    vim.notify("AutoSave " .. (enabled and "enabled" or "disabled"))
end, { desc = "Toggle automatic buffer writes" })
