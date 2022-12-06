local cmp = require('cmp')
local func = require('helpers-cmp')
local select_opts = { behavior = cmp.SelectBehavior.Select }


vim.opt.completeopt = { 'menu', 'menuone' }

local conf_snippet = {
    expand = func.snippet_expand
}

local conf_sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    {
        name = 'spell',
        option = {
            keep_all_entries = false,
            enable_in_context = function()
                return true
            end
        }
    }
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
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(select_opts), { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(select_opts), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }),{'i', 'c'}),
    ['<C-q>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(func.tab_complete, { 'i', 's', 'c' }),
    ['<S-Tab>'] = cmp.mapping(func.shift_tab_complete, { 'i', 's', 'c' })
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
