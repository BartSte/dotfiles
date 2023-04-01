local cmp = require('cmp')
local luasnip = require('luasnip')
local behavior_insert = { behavior = cmp.SelectBehavior.Insert }

local function enable_cmp(value)
    cmp.setup({ enabled = value })
end

local M = {}

--A variable to hold the state of cmp is created to make history scrolling in
--the command line easier to implement.
M.cmp_enabled = true

M.snippet_expand = function(args)
    luasnip.lsp_expand(args.body)
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
    M.restore_cmp()
    if M.cmp_enabled then
        print('cmp is enabled')
    else
        print('cmp is disabled')
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

return M
