local cmp = require('cmp')
local func = require('helpers.cmp')
local map = require('helpers.keymapper')


-- To enable history scrolling on the command line, cmp is disabled when
-- <Down> or <Up> is pressed. cmp is restored when tab/stab or space are pressed.
local up = { i = func.prev_item_insert, c = func.prev_item_cmd }
local down = { i = func.next_item_insert, c = func.next_item_cmd }
local enter = { i = func.confirm_select(false), c = func.confirm_select(false) }
local cspace = { i = func.toggle_visibility, c = func.toggle_cmp }
local menter = { i = func.confirm_select(true), c = func.confirm_select(true) }


local snippet = {
    expand = function(args)
        require('luasnip').lsp_expand(args.body)
    end
}

local mappings = {
    ['<Up>'] = cmp.mapping(up),
    ['<CR>'] = cmp.mapping(enter),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<Down>'] = cmp.mapping(down),
    ['<M-CR>'] = cmp.mapping(menter),
    ['<C-Space>'] = cmp.mapping(cspace),
}
map.nnoremap('<C-Space>', "a<cmd>lua require('helpers.cmp').enable_complete()<CR>")

local window = {
    -- Here the style of the completion window is set to the one defined in the
    -- cmp.config.window.bordered() function. You can also remove this and set
    -- the style youself.
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
}

local menu_items = {
    path = 'PATH',
    buffer = 'BUF',
    orgmode = 'ORG',
    copilot = 'COP',
    cmdline = 'CMD',
    nvim_lsp = 'LSP',
    cmdline_history = 'HIS',
}

local cmp_kinds = {
    Class = '  ',
    Color = '  ',
    Constant = '  ',
    Constructor = '  ',
    Enum = '  ',
    EnumMember = '  ',
    Event = '  ',
    Field = '  ',
    File = '  ',
    Folder = '  ',
    Function = '  ',
    Interface = '  ',
    Keyword = '  ',
    Method = '  ',
    Module = '  ',
    Operator = '  ',
    Property = '  ',
    Reference = '  ',
    Snippet = '  ',
    Struct = '  ',
    Text = '  ',
    TypeParameter = '  ',
    Unit = '  ',
    Value = '  ',
    Variable = '  ',
}

local formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = func.format({
        length = 50,
        menu = menu_items,
        kinds = cmp_kinds
    }),
}

local sources_i = {
    { name = 'orgmode' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
}

local sources_c = {
    {
        name = 'cmdline',
        option = {
            ignore_cmds = { 'Man', '!', '!r', '!read' }
        }
    },
    { name = 'cmdline_history' },
    { name = 'path' },
    { name = 'buffer' },
}

local sources_s = { { name = 'buffer' } }

cmp.setup({
    snippet = snippet,
    window = window,
    formatting = formatting,
    mapping = mappings,
    sources = sources_i,
    enabled = func.cmp_enabled,
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
