local cnoremap = require("helpers.keymapper").cnoremap
local inoremap = require("helpers.keymapper").inoremap
local nnoremap = require("helpers.keymapper").nnoremap
local noremap = require("helpers.keymapper").noremap
local onoremap = require("helpers.keymapper").onoremap
local tnoremap = require("helpers.keymapper").tnoremap
local vnoremap = require("helpers.keymapper").vnoremap

-- Override defaults
inoremap("<C-t>", "<Esc>")
noremap("<C-t>", "<Esc>")
vnoremap("p", "pgvy")
nnoremap("Y", "y$")
nnoremap("ZA", ":wqa<CR>")

-- Make J and K available for hop.nvim
noremap("<leader>j", "J")
nnoremap("<c-k>", "K")

-- Insert/command mode delete
inoremap("<C-BS>", "<C-w>")
inoremap("<C-Del>", "<C-o>dE")
inoremap("<C-h>", "<C-w>")
cnoremap("<C-BS>", "<C-w>")
cnoremap("<C-h>", "<C-w>")

-- Open links
nnoremap("gx", ":call system('open ' . expand('<cfile>'))<CR>")

-- Use <BS> and <CR> for up and down
nnoremap("<BS>", "k")
nnoremap("<CR>", "j")
onoremap("<BS>", "k")
onoremap("<CR>", "j")
vnoremap("<BS>", "k")
vnoremap("<CR>", "j")

--Shortcut to clipboard
nnoremap('+', '"+')
nnoremap('++', '<nop>')
vnoremap('+', '"+')
vnoremap('++', '<nop>')
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
noremap("<a-,>", "<cmd>cp<CR>")
noremap("<a-.>", "<cmd>cn<CR>")
noremap("<C-n>", "<cmd>bnext<CR>")
noremap("<C-p>", "<cmd>bprevious<CR>")
noremap("gF", "<cmd>wincmd v<bar>wincmd l<CR>gf")
nnoremap("<leader>;", ":e<CR>")

--Search
nnoremap("<leader>/", require("helpers.mappings").highlight_word)

--Tabs
noremap("<leader>tn", "<cmd>tabnew<CR>")
noremap("<leader>to", "<cmd>tabonly<CR>")
noremap("<leader>tc", "<cmd>tabclose<CR>")

--Formatting and refactoring
nnoremap("<leader>cs", "<cmd>setlocal spell! spell?<CR>")
nnoremap("<leader>%", "<cmd>source<CR>")
vnoremap("<silent><leader>cc", ":sort<CR>")
nnoremap("<silent><leader>cc", "vip:sort<CR>")
nnoremap("<leader>w", "<cmd>setlocal wrap! wrap?<CR>")

--Save
inoremap("<C-s>", "<cmd>silent w<CR>")
nnoremap("<leader>s", ":mksession! Session.vim<CR>")
noremap("<C-s>", "<cmd>silent w<CR>")

--Shell commands
vim.cmd("noremap <leader>cx :!chmod +x %<CR>")

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
