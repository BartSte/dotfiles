local m = require('helpers.keymapper')
local cmp = require('cmp')
local helpers = require('helpers.cmp')

-- To enable history scrolling on the command line, cmp is disabled when
-- <Down> or <Up> is pressed. cmp is restored when tab/stab or space are pressed.
local up = { i = helpers.prev_item_insert, c = helpers.prev_item_cmd }
local down = { i = helpers.next_item_insert, c = helpers.next_item_cmd }
local enter = { i = helpers.confirm_select(false), c = helpers.confirm_select(false) }
local cspace = { i = helpers.toggle_visibility, c = helpers.toggle_visibility }
local aspace = { i = helpers.toggle_cmp, c = helpers.toggle_cmp }
local menter = { i = helpers.confirm_select(true), c = helpers.confirm_select(true) }

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
    ['<M-Space>'] = cmp.mapping(aspace),
  }
})
m.nnoremap("<F24>", "a<cmd>lua require'helpers.cmp'.toggle_visibility()<CR>")
m.inoremap("<F24>", helpers.toggle_visibility)
m.cnoremap("<F24>", helpers.toggle_cmp)

cmp.setup.cmdline({ '/', '?' }, {
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  sources = {
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
})

-- To enable history scrolling on the command line, cmp is
-- disabled when with <Down> or <Up> is pressed. Therefore the state of cmp is
-- restored when leaving the command line.
vim.api.nvim_create_autocmd('CmdlineLeave', {
  desc = 'Restore nvim-cmp',
  callback = helpers.restore_cmp
})

vim.opt.completeopt = { 'menu' }
