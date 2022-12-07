local cmp = require('cmp')
local luasnip = require('luasnip')
local behavior_insert = { behavior = cmp.SelectBehavior.Insert }

M = {}

M.snippet_expand = function(args)
    luasnip.lsp_expand(args.body)
end

M.formatter = function(entry, item)
    local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '/',
    }
    item.menu = menu_icon[entry.source.name]
    return item
end

M.up_cmp_i = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        fallback()
    end
end

M.up_cmp_cs = function(_)
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        cmp.complete()
    end
end

M.down_cmp_i = function(fallback)
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        fallback()
    end
end

M.down_cmp_cs = function(_)
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        cmp.complete()
    end
end

M.toggle_cmp = function()
    if cmp.visible() then
        cmp.abort()
    else
        cmp.complete()
    end
end

return M
