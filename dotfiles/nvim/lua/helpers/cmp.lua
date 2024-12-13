local cmp = require('cmp')
local behavior_insert = { behavior = cmp.SelectBehavior.Insert }

local function notify(msg, level)
    if vim.api.nvim_get_mode().mode ~= 'c' then
        level = level or vim.log.levels.INFO
        vim.api.nvim_notify(msg, level, {})
    end
end

local function enable_cmp(value)
    cmp.setup({ enabled = value })
end

local M = {}

--A variable to hold the state of cmp is created to make history scrolling in
--the command line easier to implement.
M.cmp_enabled = true

--- Enable cmp and show the pum.
M.enable_complete = function()
    if not M.cmp_enabled then
        notify("cmp is enabled")
    end
    M.cmp_enabled = true
    enable_cmp(M.cmp_enabled)
    cmp.complete()
end

--- Disable cmp and hide the pum.
M.disable_abort = function()
    if M.cmp_enabled then
        notify("cmp is disabled")
    end
    M.cmp_enabled = false
    enable_cmp(M.cmp_enabled)
    cmp.abort()
    notify("cmp is disabled")
end

M.toggle_visibility = function()
    if cmp.visible() then
        cmp.abort()
    else
        cmp.complete()
    end
end

M.restore_cmp = function()
    enable_cmp(M.cmp_enabled)
end

--- Restore cmp state and apply fallback.
---@param fallback
M.restore_with_fallback = function(fallback)
    M.restore_cmp()
    fallback()
end

M.toggle_cmp = function()
    M.cmp_enabled = not M.cmp_enabled
    if M.cmp_enabled then
        M.enable_complete()
    else
        M.disable_abort()
    end
end

M.formatter_before = function(menu_icon)
    return function(entry, item)
        item.menu = menu_icon[entry.source.name]
        return item
    end
end

M.prev_item_insert = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        fallback()
    end
end

M.next_item_insert = function(fallback)
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        fallback()
    end
end

--- Disables cmp with omitting M.cmp_enabled. The state of cmp can be restored
--by using M.restore_cmp.
---@param fallback
--See documentation of nvim-cmp
M.next_item_cmd = function(fallback)
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        enable_cmp(false)
        fallback()
    end
end

--- See next_item_cmd
---@param fallback
--See documentation of nvim-cmp
M.prev_item_cmd = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        enable_cmp(false)
        fallback()
    end
end


--- Used to trigger completion and is equivalent to <Tab> on cli's.
M.next_item_or_enable_cmd = function()
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        M.restore_cmp()
        cmp.complete()
    end
end

--- Used to trigger completion and is equivalent to <S-Tab> on cli's.
M.prev_item_or_enable_cmd = function()
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        M.restore_cmp()
        cmp.complete()
    end
end

M.confirm_select = function(value)
    return cmp.mapping.confirm({ select = value })
end

--- For a cmp mapping function called `callback` the original fallback is
--- replaced with an empty function, next the `new_fallback` is called.
---@param callback function The cmp mapping function
---@param new_fallback function The new fallback function
---@return function mapping_function The new mapping function
M.change_fallback = function(callback, new_fallback)
    local empty_fallback = function() end
    return function(old_fallback)
        callback(empty_fallback)
        new_fallback()
    end
end

M.send_term_key = function(code)
    local key = vim.api.nvim_replace_termcodes(code, true, false, true)
    vim.api.nvim_feedkeys(key, 'n', false)
end

M.format = function(opts)
    return function(entry, vim_item)
        vim_item.abbr = string.sub(vim_item.abbr, 1, opts.length)
        vim_item.menu = opts.menu[entry.source.name]
        if vim_item.kind ~= nil then
            vim_item.kind = (opts.kinds[vim_item.kind] or '') .. vim_item.kind
        end
        return vim_item
    end
end

M.expand = function(args)
    require('luasnip').lsp_expand(args.body)
end

return M
