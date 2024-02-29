local keymapper = require("helpers.keymapper")

vim.opt_local.colorcolumn = '100'
vim.opt_local.textwidth = 100

keymapper.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader><leader>n', ':setlocal tw=0<CR>A  # noqa<Esc>^<cmd>setlocal tw=79<CR>')

keymapper.buffer_nnoremap('gl', ':TestVisit<CR>')

keymapper.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytesttmux<CR>')
keymapper.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytesttmux<CR>')
keymapper.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytesttmux<CR>')

keymapper.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytesttmuxdebug<CR>')
keymapper.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytesttmuxdebug<CR>')
keymapper.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytesttmuxdebug<CR>')

local function format()
    require("helpers.cmd").keep_position("%!autoflake --remove-all-unused-imports --remove-unused-variables --in-place -")
    require("helpers.cmd").keep_position("normal! gggqG")
end

-- TODO: override other maggings!
keymapper.buffer_nnoremap("<leader><leader>f", format)

