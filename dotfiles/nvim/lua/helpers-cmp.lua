local cmp = require('cmp')
local luasnip = require('luasnip')
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

M.tab_complete = function(fallback)
    local col = vim.fn.col('.') - 1

    if cmp.visible() then
        cmp.confirm({ select = true })
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
    else
        cmp.complete()
    end
end

M.shift_tab_complete = function(fallback)
    if cmp.visible() then
        cmp.confirm()
    else
        fallback()
    end
end

M.return_cmd = function(fallback)
    if cmp.visible() then
        cmp.confirm({ select = false })
        vim.api.nvim_feedkeys(carriage_return, 'm', false)
    else
        fallback()
    end
end

return M
