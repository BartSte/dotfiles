local cmp = require('cmp')
local func = require('helpers-cmp')
local mapper = require("keymapper")


-- To enable history scrolling on the command line, cmp is disabled when
-- <Down> or <Up> is pressed. cmp is restored when tab/stab or space are pressed.
local up = { i = func.prev_item_insert, c = func.prev_item_cmd }
local tab = { i = func.next_item_insert, c = func.next_item_or_enable_cmd }
local down = { i = func.next_item_insert, c = func.next_item_cmd }
local stab = { i = func.prev_item_insert, c = func.prev_item_or_enable_cmd }
local space = { c = func.restore_with_fallback }
local enter = { i = func.confirm_select(false), c = func.confirm_select(false) }
local cspace = { i = func.toggle_visibility, c = func.toggle_visibility }
local menter = { i = func.confirm_select(true), c = func.confirm_select(true) }

local mappings = {
    ['<Up>'] = cmp.mapping(up),
    ['<CR>'] = cmp.mapping(enter),
    ['<Tab>'] = cmp.mapping(tab),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<Down>'] = cmp.mapping(down),
    ['<M-CR>'] = cmp.mapping(menter),
    ['<S-Tab>'] = cmp.mapping(stab),
    ['<Space>'] = cmp.mapping(space),
    ['<C-Space>'] = cmp.mapping(cspace),
}

local window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
}

local snippet = { expand = func.snippet_expand }

local menu_items = {
    path = 'PATH',
    buffer = 'BUF',
    orgmode = 'ORG',
    cmdline = 'CMD',
    luasnip = 'SNIP',
    nvim_lsp = 'LSP',
    cmdline_history = 'HIS',
}

local formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = func.format({
        length = 50,
        menu = menu_items
    }),
}

local sources_i = {
    { name = 'orgmode', priority = 1, keyword_length = 1 },
    { name = 'path', priority = 2, keyword_length = 1 },
    { name = 'buffer', priority = 4, keyword_length = 1 },
    { name = 'luasnip', priority = 3, keyword_length = 1 },
    { name = 'nvim_lsp', priority = 5, keyword_length = 1 },
}

local sources_c = {
    { name = 'path', priority = 1, keyword_length = 1 },
    { name = 'cmdline', priority = 3, keyword_length = 1 },
    { name = 'cmdline_history', priority = 2, keyword_length = 1 },
}

local sources_s = { { name = 'buffer' } }

cmp.setup({
    snippet = snippet,
    window = window,
    formatting = formatting,
    mapping = mappings,
    sources = sources_i,
    enabled = func.cmp_enabled
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    sources = sources_s
})

cmp.setup.cmdline(':', {
    sources = sources_c
})

-- To enable history scrolling on the command line, cmp is
-- disabled when with <Down> or <Up> is pressed. Therefore the state of cmp is
-- restored when leaving the command line.
vim.api.nvim_create_autocmd('CmdlineLeave', {
    desc = 'Restore nvim-cmp',
    callback = func.restore_cmp
})

vim.opt.completeopt = { 'menu' }
mapper.nnoremap('<C-Space>', "a<cmd>lua require('helpers-cmp').toggle_visibility()<CR>")