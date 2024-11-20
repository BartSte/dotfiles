local sorters = require("helpers.sorters")
local m = require("helpers.keymapper")

--------------------------------------------------------------------------------
--- Override defaults
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
m.nnoremap('""', ':reg<CR>')

--------------------------------------------------------------------------------
-- Control key
-- The control key should be used for mapping native vim commands. In general,
-- the control key should be avoided as it is often used by vim or plugins. This
-- way, it is easier to adopt the defaults.
--------------------------------------------------------------------------------
m.tnoremap("<C-t>", "<C-\\><C-n>") -- enter normal mode in terminal
m.inoremap("<C-t>", "<Esc>")       -- exit insert mode
m.noremap("<C-t>", "<Esc>")
m.nnoremap("<c-k>", "K")           -- make K available for hop.nvim

-- save file
m.inoremap("<C-s>", "<cmd>silent w<CR>")
m.noremap("<C-s>", "<cmd>silent w<CR>")

-- Insert/command mode delete
m.cnoremap("<C-BS>", "<C-w>")
m.cnoremap("<C-h>", "<C-w>")
m.inoremap("<C-BS>", "<C-w>")
m.inoremap("<C-Del>", "<C-o>dE")
m.inoremap("<C-h>", "<C-w>")

--------------------------------------------------------------------------------
-- Alt commands
-- For navigation between buffers and windows.
--------------------------------------------------------------------------------
--- Quickfix buffer navigation
m.nnoremap("<a-,>", ":cprev<CR>")
m.nnoremap("<a-.>", ":cnext<CR>")

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
    | t   | tabs                  |          |
    | j   | join                  |          |
    | ;   | reload                |          |
    | /   | highlight             |          |
    | l   | lsp                   |          | TODO
    | v   | vim commands          |          |
    | g   | git                   | fugitive |
    | r   | rename                | lsp      | 
    | q   | delete buffer         | vim-bbye |
    | o   | org commands          | orgmode  |
    | n   | neogen                | neogen   |
--]]
--------------------------------------------------------------------------------
--Tabs
m.noremap("<leader>tn", "<cmd>tabnew<CR>")
m.noremap("<leader>to", "<cmd>tabonly<CR>")
m.noremap("<leader>tc", "<cmd>tabclose<CR>")

-- Vim commands
m.noremap("<leader>j", "J") -- make available for hop.nvim
m.nnoremap("<leader>vw", ":setlocal wrap! wrap?<CR>")
m.nnoremap("<leader>vs", require("helpers.session").save)
m.nnoremap("<leader>vl", require("helpers.session").load)

--Shell commands
vim.cmd("noremap <leader>cx :!chmod +x %<CR>")
m.nnoremap("<leader>cc", sorters.charsort.ofunc)
m.vnoremap("<leader>cc", sorters.charsort.vfunc)
m.nnoremap("<leader>c=", sorters.lensort.ofunc)
m.vnoremap("<leader>c=", sorters.lensort.vfunc)

-- Customs
m.nnoremap("<leader>/", require("helpers.mappings").highlight_word)

--------------------------------------------------------------------------------
-- The terminal does not detect <C-Space>. As a solution, Alacritty sends <F24>
-- when ctrl+space is pressed. By binding <C-Space> to <F24> (or <S-F12>), the
-- issue is solved.
--------------------------------------------------------------------------------
vim.cmd("map <F24> <C-Space>")
vim.cmd("map <S-F12> <C-Space>")
vim.cmd("imap <F24> <C-Space>")
vim.cmd("cmap <F24> <C-Space>")
vim.cmd("nmap <F24> <C-Space>")
vim.cmd("imap <S-F12> <C-Space>")
vim.cmd("cmap <S-F12> <C-Space>")
vim.cmd("nmap <S-F12> <C-Space>")
