"alt mappings a re for moving out of the editor -> alt==appear
"leader mappings are for text editing.
"control mappings are kept at the default where possible, e.g., fzf's <C-t>

"Insert mode 
inoremap <C-BS> <C-w>
inoremap <C-h> <C-w>
inoremap <C-Del> <C-o>dE
inoremap <C-t> <Esc>
inoremap <C-s> <C-o><cmd>w<CR>

" Command mode
cnoremap <C-BS> <C-w>
cnoremap <C-h> <C-w>

"Override default mappings
nnoremap <silent><c-k> K
onoremap <CR> j
onoremap <BS> k
nnoremap <CR> j
nnoremap <BS> k
vnoremap <CR> j
vnoremap <BS> k
nnoremap Y y$
noremap <C-s> <cmd>w<CR>
vnoremap p pgvy
nnoremap <leader>j J

" Terminal mode
tnoremap <C-t> <C-\><C-n>
map <a-q> <cmd>wincmd v<bar>term<CR>mQ
map <a-Q> <cmd>only<bar>wincmd v<bar>term<CR>mQ

" Window navigation
nnoremap <C-w>m <C-w>H 
nnoremap <C-w>n <C-w>J  
nnoremap <C-w>e <C-w>K 
nnoremap <C-w>i <C-w>L 
nnoremap <a-e> <C-w>k
nnoremap <a-m> <C-w>h
nnoremap <a-i> <C-w>l
nnoremap <a-n> <C-w>j

"buffer navigation
noremap <silent><C-n> <cmd>bnext<CR>
noremap <silent><C-p> <cmd>bprevious<CR>
noremap <silent><a-,> <cmd>cp<CR>
noremap <silent><a-.> <cmd>cn<CR>

"Search
nnoremap <leader>/ *#<cmd>setlocal hlsearch<CR>
nnoremap <leader><leader>/ <cmd>set hlsearch! hlsearch?<CR>

"Tabs
noremap <leader>tc <cmd>tabclose<CR>
noremap <leader>to <cmd>tabonly<CR>
noremap <leader>tn <cmd>tabnew<CR>

"Formatting and refactoring
nnoremap <silent><leader>f mxgggqG`x
nnoremap <silent><leader>w <cmd>setlocal wrap! wrap?<CR>
nnoremap <silent><leader>cc vip<cmd>sort<CR>
nnoremap <silent><leader>cl vip<cmd>!sort_variable_length<CR>
vnoremap <silent><leader>cc :sort<CR>
vnoremap <silent><leader>cl :!sort_variable_length<CR>
