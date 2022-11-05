local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }

M = {}

M.snippet_expand = function (args)
    luasnip.lsp_expand(args.body)
end

M.formatter = function (entry, item)
    local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '/',
    }
    item.menu = menu_icon[entry.source.name]
    return item
end

M.tab_complete = function (fallback)
    local col = vim.fn.col('.') - 1

    if cmp.visible() then
        cmp.select_next_item(select_opts)
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
    else
        cmp.complete()
    end
end

M.shift_tab_complete = function (fallback)
    if cmp.visible() then
        cmp.select_prev_item(select_opts)
    else
        fallback()
    end
end

return M
