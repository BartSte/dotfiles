local sorters = require("helpers.sorters")
local noremap = require("helpers.keymapper").noremap
local cnoremap = require("helpers.keymapper").cnoremap
local inoremap = require("helpers.keymapper").inoremap
local nnoremap = require("helpers.keymapper").nnoremap
local onoremap = require("helpers.keymapper").onoremap
local tnoremap = require("helpers.keymapper").tnoremap
local vnoremap = require("helpers.keymapper").vnoremap

-- Override defaults
inoremap("<C-t>", "<Esc>")
nnoremap("Y", "y$")
nnoremap("ZA", ":wqa<CR>")
noremap("<C-t>", "<Esc>")
vnoremap("p", "pgvy")

-- Make J and K available for hop.nvim
nnoremap("<c-k>", "K")
noremap("<leader>j", "J")

-- Insert/command mode delete
cnoremap("<C-BS>", "<C-w>")
cnoremap("<C-h>", "<C-w>")
inoremap("<C-BS>", "<C-w>")
inoremap("<C-Del>", "<C-o>dE")
inoremap("<C-h>", "<C-w>")

-- Use <BS> and <CR> for up and down
nnoremap("<BS>", "k")
onoremap("<BS>", "k")
vnoremap("<BS>", "k")

-- Register shortcuts
nnoremap('+', '"+')
vnoremap('+', '"+')
nnoremap("_", '"_')
vnoremap("_", '"_')
nnoremap('""', ':reg<CR>')

-- Terminal mode
tnoremap("<C-t>", "<C-\\><C-n>")

-- Window navigation
nnoremap("<a-m>", "<C-w>h")
nnoremap("<a-e>", "<C-w>k")
nnoremap("<a-i>", "<C-w>l")
nnoremap("<a-n>", "<C-w>j")
nnoremap("<C-w>m", "<C-w>H")
nnoremap("<C-w>e", "<C-w>K")
nnoremap("<C-w>i", "<C-w>L")
nnoremap("<C-w>n", "<C-w>J")
nnoremap("<C-w>z", ":wincmd o<bar>vert new<bar>vert resize 70<CR><C-w>l")
nnoremap("<C-w>a", ":wincmd o<bar>wincmd v<CR>")

-- Quickfix
nnoremap("Q", require("helpers.wininfo").toggle_quickfix)
nnoremap("<a-.>", ":cnext<CR>")
nnoremap("<a-,>", ":cprev<CR>")

--buffer navigation
noremap("gF", "<cmd>wincmd v<bar>wincmd l<CR>gf")
nnoremap("<leader>;", ":e<CR>")

--Search
nnoremap("<leader>/", require("helpers.mappings").highlight_word)

--Tabs
noremap("<leader>tn", "<cmd>tabnew<CR>")
noremap("<leader>to", "<cmd>tabonly<CR>")
noremap("<leader>tc", "<cmd>tabclose<CR>")

--Formatting and refactoring
nnoremap("<leader>%", "<cmd>source<CR>")
nnoremap("<leader>w", "<cmd>setlocal wrap! wrap?<CR>")

--Save
inoremap("<C-s>", "<cmd>silent w<CR>")
nnoremap("<leader>s", ":mksession! Session.vim<CR>")
noremap("<C-s>", "<cmd>silent w<CR>")

--Shell commands are prefixed with <leader>c
vim.cmd("noremap <leader>cx :!chmod +x %<CR>")
nnoremap("<leader>cc", sorters.charsort.ofunc)
vnoremap("<leader>cc", sorters.charsort.vfunc)
-- TODO: make lensort pass the last key pressed to the lensort function itself
nnoremap("<leader>c=", sorters.lensort.ofunc)
vnoremap("<leader>c=", sorters.lensort.vfunc)

-- The terminal does not detect <C-Space>. As a solution, Alacritty sends <F24>
-- when ctrl+space is pressed. By binding <C-Space> to <F24> (or <S-F12>), the
-- issue is solved.
vim.cmd("map <F24> <C-Space>")
vim.cmd("map <S-F12> <C-Space>")
vim.cmd("imap <F24> <C-Space>")
vim.cmd("cmap <F24> <C-Space>")
vim.cmd("nmap <F24> <C-Space>")
vim.cmd("imap <S-F12> <C-Space>")
vim.cmd("cmap <S-F12> <C-Space>")
vim.cmd("nmap <S-F12> <C-Space>")
