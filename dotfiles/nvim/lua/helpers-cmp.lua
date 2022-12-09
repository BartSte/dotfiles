local cmp = require('cmp')
local luasnip = require('luasnip')
local behavior_insert = { behavior = cmp.SelectBehavior.Insert }

M = {}

M.snippet_expand = function(args)
    luasnip.lsp_expand(args.body)
end

M.formatter = function(entry, item)
    local menu_icon = {
        buffer = 'buf',
        cmdline = 'cmd',
        cmdline_history = 'his',
        luasnip = 'sni',
        nvim_lsp = 'lsp',
        path = 'path',
    }
    item.menu = menu_icon[entry.source.name]
    return item
end

M.prev_item_or_fallback = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item(behavior_insert)
    else
        fallback()
    end
end

M.next_item_or_fallback = function(fallback)
    if cmp.visible() then
        cmp.select_next_item(behavior_insert)
    else
        fallback()
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
