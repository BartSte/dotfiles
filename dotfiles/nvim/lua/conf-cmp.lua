local cmp = require('cmp')
local func = require('helpers-cmp')

vim.opt.completeopt = { 'menu', 'menuone' }

local conf_snippet = { expand = func.snippet_expand }

local spell_options = {
    keep_all_entries = false,
    enable_in_context = function() return true end
}

local conf_sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'spell', option = spell_options }
}

local conf_window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
}

local conf_formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = func.formatter,
}

local conf_mappings = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),

    ['<Up>'] = cmp.mapping({ i = func.up_cmp_i, c = func.up_cmp_cs }),
    ['<S-Tab>'] = cmp.mapping({ i = func.up_cmp_i, c = func.up_cmp_cs }),
    ['<Tab>'] = cmp.mapping({ i = func.down_cmp_i, c = func.down_cmp_cs }),
    ['<Down>'] = cmp.mapping({ i = func.down_cmp_i, c = func.down_cmp_cs }),

    ['<C-Space>'] = cmp.mapping(func.toggle_cmp, { 'i', 'c' }),
    ['<M-CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' })
}

cmp.setup({
    snippet = conf_snippet,
    sources = conf_sources,
    window = conf_window,
    formatting = conf_formatting,
    mapping = conf_mappings
})

cmp.setup.cmdline({ '/', '?' }, {
    sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
