local sorters = require("helpers.sorters")
local m = require("helpers.keymapper")

-- <C-b> is reserved as a "leader" in insert mode

-- Unused:
-- k, j, l, L

--------------------------------------------------------------------------------
--- No modifiers
--------------------------------------------------------------------------------
m.nnoremap("Y", "y$")
m.nnoremap("ZA", ":wqa<CR>")
m.vnoremap("p", "pgvy")
m.nnoremap("Q", require("helpers.wininfo").toggle_quickfix)
m.noremap("gF", "<cmd>wincmd v<bar>wincmd l<CR>gf")

-- Use <BS> for moving up
m.nnoremap("<BS>", "k")
m.onoremap("<BS>", "k")
m.vnoremap("<BS>", "k")

-- Register shortcuts
m.nnoremap('+', '"+')
m.vnoremap('+', '"+')
m.nnoremap("_", '"_')
m.vnoremap("_", '"_')

--------------------------------------------------------------------------------
-- Control key
-- The control key should be used for mapping native vim commands. In general,
-- the control key should be avoided as it is often used by vim or plugins. This
-- way, it is easier to adopt the defaults.
--------------------------------------------------------------------------------

-- Insert/command mode delete
m.cnoremap("<C-BS>", "<C-w>")
m.cnoremap("<C-h>", "<C-w>")
m.inoremap("<C-BS>", "<C-w>")
m.inoremap("<C-Del>", "<C-o>dE")
m.inoremap("<C-h>", "<C-w>")

--- Quickfix buffer navigation
m.nnoremap("<C-p>", ":cprev<CR>")
m.nnoremap("<C-n>", ":cnext<CR>")
--------------------------------------------------------------------------------
-- Alt commands
-- For navigation between buffers and windows.
--------------------------------------------------------------------------------
-- Window navigation
m.nnoremap("<a-m>", "<C-w>h")
m.nnoremap("<a-e>", "<C-w>k")
m.nnoremap("<a-i>", "<C-w>l")
m.nnoremap("<a-n>", "<C-w>j")

-- Fill up the bindings that are now unused due to the alt bindsings.
m.nnoremap("<C-w>m", "<C-w>H")
m.nnoremap("<C-w>e", "<C-w>K")
m.nnoremap("<C-w>i", "<C-w>L")
m.nnoremap("<C-w>n", "<C-w>J")
m.nnoremap("<C-w>z", ":wincmd o<bar>vert new<bar>vert resize 70<CR><C-w>l")
m.nnoremap("<C-w>a", ":wincmd o<bar>wincmd v<CR>")
m.nnoremap("<C-w>]", ":wincmd v<CR><C-]>")
--------------------------------------------------------------------------------
-- Leader commands
-- Use the leader key for manipulating the text and appearance of a buffer and
-- the command line.
--
-- Bindings related to a plugin are set in the plugin config.
--[[
    | Key | Description           | Plugin   |
    | c   | shell commands        |          |
    | f   | format whole document |          |
    | t   | tabs/tests            |          |
    | v   | vim commands          |          |
    | /   | highlight word        |          |
    | l   | lsp                   | lsp      |
    | g   | git                   | fugitive |
    | q   | delete buffer         | bufdelete|
    | o   | org commands          | orgmode  |
    | n   | notifier              | neogen   |
--]]
--------------------------------------------------------------------------------
--Tabs
m.noremap("<leader>tn", "<cmd>tabnew<CR>")
m.noremap("<leader>to", "<cmd>tabonly<CR>")
m.noremap("<leader>tc", "<cmd>tabclose<CR>")

-- Vim commands
m.nnoremap("<leader>vs", require("helpers.session").save)
m.nnoremap("<leader>vl", require("helpers.session").load)
m.silent_nnoremap("<leader>vw", ":setlocal wrap! wrap?<CR>")
m.silent_nnoremap("<leader>vr", ":e<CR>")

--Shell commands
vim.cmd("noremap <leader>cx :!chmod +x %<CR>")
m.nnoremap("<leader>cc", sorters.charsort.ofunc)
m.vnoremap("<leader>cc", sorters.charsort.vfunc)
m.nnoremap("<leader>c=", sorters.lensort.ofunc)
m.vnoremap("<leader>c=", sorters.lensort.vfunc)

-- Customs
m.nnoremap("<leader>/", require("helpers.mappings").highlight_word)
