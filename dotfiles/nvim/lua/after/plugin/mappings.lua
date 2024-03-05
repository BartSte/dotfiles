local map = require("helpers.keymapper")

-- Override defaults
map.inoremap("<C-t>", "<Esc>")
map.noremap("<C-t>", "<Esc>")
map.vnoremap("p", "pgvy")
map.nnoremap("Y", "y$")
map.nnoremap("ZA", ":wqa<CR>")

-- Make J and K available for hop.nvim
map.noremap("<leader>j", "J")
map.nnoremap("<c-k>", "K")

-- Insert/command mode delete
map.inoremap("<C-BS>", "<C-w>")
map.inoremap("<C-Del>", "<C-o>dE")
map.inoremap("<C-h>", "<C-w>")
map.cnoremap("<C-BS>", "<C-w>")
map.cnoremap("<C-h>", "<C-w>")

-- Open links
map.nnoremap("gx", ":call system('open ' . expand('<cfile>'))<CR>")

-- Use <BS> and <CR> for up and down
map.nnoremap("<BS>", "k")
map.nnoremap("<CR>", "j")
map.onoremap("<BS>", "k")
map.onoremap("<CR>", "j")
map.vnoremap("<BS>", "k")
map.vnoremap("<CR>", "j")

--Shortcut to clipboard
map.nnoremap('+', '"+')
map.nnoremap('++', '<nop>')
map.vnoremap('+', '"+')
map.vnoremap('++', '<nop>')
map.nnoremap('""', ':reg<CR>')

-- Terminal mode
map.tnoremap("<C-t>", "<C-\\><C-n>")

-- Window navigation
map.nnoremap("<a-m>", "<C-w>h")
map.nnoremap("<a-e>", "<C-w>k")
map.nnoremap("<a-i>", "<C-w>l")
map.nnoremap("<a-n>", "<C-w>j")
map.nnoremap("<C-w>m", "<C-w>H")
map.nnoremap("<C-w>e", "<C-w>K")
map.nnoremap("<C-w>i", "<C-w>L")
map.nnoremap("<C-w>n", "<C-w>J")
map.nnoremap("<C-w>z", ":wincmd o<bar>vert new<bar>vert resize 80<CR><C-w>l")
map.nnoremap("<C-w>a", ":wincmd o<bar>wincmd v<CR>")

-- Quickfix
map.nnoremap("Q", require("helpers.wininfo").toggle_quickfix)
map.nnoremap("<a-.>", ":cnext<CR>")
map.nnoremap("<a-,>", ":cprev<CR>")

--buffer navigation
map.noremap("<a-,>", "<cmd>cp<CR>")
map.noremap("<a-.>", "<cmd>cn<CR>")
map.noremap("<C-n>", "<cmd>bnext<CR>")
map.noremap("<C-p>", "<cmd>bprevious<CR>")
map.noremap("gF", "<cmd>wincmd v<bar>wincmd l<CR>gf")
map.nnoremap("<leader>;", ":e<CR>")

--Search
map.nnoremap("<leader>/", "*#<cmd>setlocal hlsearch<CR>")

--Tabs
map.noremap("<leader>tn", "<cmd>tabnew<CR>")
map.noremap("<leader>to", "<cmd>tabonly<CR>")
map.noremap("<leader>tc", "<cmd>tabclose<CR>")

--Formatting and refactoring
map.nnoremap("<leader>cs", "<cmd>setlocal spell! spell?<CR>")
map.nnoremap("<leader>%", "<cmd>source<CR>")
map.vnoremap("<silent><leader>cc", ":sort<CR>")
map.nnoremap("<silent><leader>cc", "vip:sort<CR>")
map.nnoremap("<leader>w", "<cmd>setlocal wrap! wrap?<CR>")

--Save
map.inoremap("<C-s>", "<cmd>w<CR>")
map.nnoremap("<leader>s", ":mksession! Session.vim<CR>")
map.noremap("<C-s>", "<cmd>w<CR>")

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