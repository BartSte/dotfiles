local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }
local carriage_return = vim.api.nvim_replace_termcodes('<CR>', true, true, true)

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

M.tab_cmp = function(fallback)
    local col = vim.fn.col('.') - 1

    if cmp.visible() then
        cmp.select_next_item(select_opts)
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
    else
        cmp.complete()
    end
end

M.shift_tab_cmp = function(fallback)
    local col = vim.fn.col('.') - 1

    if cmp.visible() then
        cmp.select_prev_item(select_opts)
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
    else
        cmp.complete()
    end
end

M.toggle_cmp = function ()
    if cmp.visible() then
        cmp.close()
        -- TODO, when closing the auto complete pops u agaen when a char it
        -- typed.
    else
        cmp.complete()
    end
end

return M
