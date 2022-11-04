local cmp = require('cmp')
local compare = require('cmp.config.compare')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }
require('luasnip.loaders.from_vscode').lazy_load()

local function snippet_expand(args)
    luasnip.lsp_expand(args.body)
end

local function formatter(entry, item)
    local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '/',
    }
    item.menu = menu_icon[entry.source.name]
    return item
end

vim.opt.completeopt = { 'menu', 'menuone' }

local conf_sorting = {
    comparators = {
        compare.recently_used,
        compare.locality,
        compare.offset,
        compare.exact,
        compare.score,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
    },
}

local conf_snippet = {
    expand = snippet_expand
}

local conf_sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
}

local conf_window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
}

local conf_formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = formatter,
}

local conf_mappings = {
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(select_opts), { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(select_opts), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), {'i', 'c'}),
    ['<C-q>'] = cmp.mapping(cmp.mapping.abort(), {'i', 'c'})
}

cmp.setup({
    sorting = conf_sorting,
    snippet = conf_snippet,
    sources = conf_sources,
    window = conf_window,
    formatting = conf_formatting,
    mapping = conf_mappings
})


cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
