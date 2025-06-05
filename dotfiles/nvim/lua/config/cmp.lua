local m = require('helpers.keymapper')
local cmp = require('cmp')
local helpers = require('helpers.cmp')

-- To enable history scrolling on the command line, cmp is disabled when
-- <Down> or <Up> is pressed. cmp is restored when cspace is pressed.
local aspace = { i = helpers.disable_abort, c = helpers.disable_abort, n = helpers.disable_abort }
local cspace = {
    i = helpers.enable_complete,
    c = helpers.enable_complete,
    n = "a<cmd>lua require('helpers.cmp').enable_complete() <CR>"
}
local down = { i = helpers.next_item_insert, c = helpers.next_item_cmd }
local enter = { i = helpers.confirm_select(false), c = helpers.confirm_select(false) }
local menter = { i = helpers.confirm_select(true), c = helpers.confirm_select(true) }
local up = { i = helpers.prev_item_insert, c = helpers.prev_item_cmd }

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

cmp.setup({
    enabled = helpers.cmp_enabled,
    snippet = { expand = helpers.expand },
    formatting = {
        expandable_indicator = true,
        fields = { 'abbr', 'kind', 'menu' },
        format = helpers.format({
            length = 50,
            menu = menu_items,
            kinds = cmp_kinds
        }),
    },
    sources = {
        { name = 'orgmode' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    mapping = {
        ['<Up>'] = cmp.mapping(up),
        ['<CR>'] = cmp.mapping(enter),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<Down>'] = cmp.mapping(down),
        ['<M-CR>'] = cmp.mapping(menter),
        ['<C-space>'] = cmp.mapping(cspace),
        ['<M-space>'] = cmp.mapping(aspace)
    }
})

--- For cspace to work consistenly across windows and linux within a terminal, I
--- let Alacritty send F24 when <C-space> is pressed.
m.cnoremap("<F24>", cspace.c)
m.inoremap("<F24>", cspace.i)
m.nnoremap("<F24>", cspace.n)
m.nnoremap("<M-Space>", aspace.n)

cmp.setup.cmdline({ '/', '?' }, {
    sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
    sources = {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!', '!r', '!read' }
            },
            priority = 4,
        },
        { name = 'cmdline_history', priority = 3 },
        { name = 'path',            priority = 2 },
        { name = 'buffer',          priority = 1 },
    }
})

-- To enable history scrolling on the command line, cmp is
-- disabled when with <Down> or <Up> is pressed. Therefore the state of cmp is
-- restored when leaving the command line.
vim.api.nvim_create_autocmd('CmdlineLeave', {
    desc = 'Restore nvim-cmp',
    callback = helpers.restore_cmp
})

vim.opt.completeopt = { 'menu' }
