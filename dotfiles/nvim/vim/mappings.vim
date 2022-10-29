"alt mappings a re for moving out of the editor -> alt==appear
"leader mappings are for text editing.
"control mappings are kept at the default where possible, e.g., fzf's <C-t>

"Insert mode 
inoremap <C-BS> <C-W>
inoremap <C-h> <C-W>
inoremap <C-Del> <C-o>dE
inoremap <C-t> <Esc>
inoremap <C-s> <C-o>:w<CR>

"Override default mappings
onoremap <CR> j
onoremap <BS> k
nnoremap <CR> j
nnoremap <BS> k
vnoremap <CR> j
vnoremap <BS> k
nnoremap Y y$
noremap <C-s> :w<CR>
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
noremap 'a 'A'"
noremap 'd 'D'"
noremap 's 'S'"
noremap 't 'T'"
noremap 'q 'Q'"
noremap <silent><C-n> :bnext<CR>
noremap <silent><C-p> :bprevious<CR>
noremap <silent><a-,> :cp<CR>
noremap <silent><a-.> :cn<CR>
noremap ma mA
noremap md mD
noremap ms mS
noremap mt mT

"Search
nnoremap <leader>/ *#:set hlsearch<CR>

"Tabs
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>

"Config file edit and load
noremap <leader>% :so %<CR>

"Formatting and refactoring
noremap <silent><leader>w :setlocal wrap! wrap?<CR>
noremap <silent><leader>cc vip:sort<CR>
noremap <silent><leader>cl vip:!sort_variable_length<CR>
vnoremap <silent><leader>cc :sort<CR>
vnoremap <silent><leader>cl :!sort_variable_length<CR>
