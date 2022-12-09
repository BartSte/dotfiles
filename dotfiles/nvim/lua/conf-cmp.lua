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
    fields = { 'abbr', 'kind', 'menu' },
    format = func.formatter,
}

local conf_mappings = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),

    ['<Up>'] = cmp.mapping(func.prev_item_or_fallback, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(func.prev_item_or_fallback, { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(func.next_item_or_fallback, { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(func.next_item_or_fallback, { 'i', 'c' }),

    ['<C-Space>'] = cmp.mapping(func.toggle_cmp),
    ['<M-CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }))
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

local conf_formatting_cmd = {
    fields = { 'abbr', 'kind', 'menu' },
    format = func.formatter
}

cmp.setup.cmdline(':', {
    formatting = conf_formatting_cmd,
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'cmdline_history' },
        { name = 'path' },
    })
})
