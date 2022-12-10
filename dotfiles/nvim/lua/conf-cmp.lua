local cmp = require('cmp')
local func = require('helpers-cmp')
local lspkind = require('lspkind')

vim.opt.completeopt = { 'menu' }

local conf_snippet = { expand = func.snippet_expand }

local conf_sources = {
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
}

local conf_window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
}

local formatter = lspkind.cmp_format({
    mode = 'symbol_text',
    maxwidth = 50,
    ellipsis_char = '...',
    before = func.formatter_before
})

local conf_formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = formatter,
}

local conf_mappings = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),

    ['<Up>'] = cmp.mapping({i = func.prev_item_or_fallback, c = func.prev_item}),
    ['<S-Tab>'] = cmp.mapping({i = func.next_item_or_fallback, c = func.next_item}),
    ['<Tab>'] = cmp.mapping({i = func.prev_item_or_fallback, c = func.prev_item}),
    ['<Down>'] = cmp.mapping({i = func.next_item_or_fallback, c = func.next_item}),

    ['<C-Space>'] = cmp.mapping(func.toggle_cmp),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false })),
    ['<M-CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true })),

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
    formatting = conf_formatting,
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'path' },
        { name = 'cmdline_history' },
    }),
})

vim.cmd("cnoremap <M-h> <cmd>lua require('cmp').complete({ config = { sources = { { name = 'cmdline_history' } } } })<CR>")
vim.cmd("nmap <M-h> :<M-h>")
