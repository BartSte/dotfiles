" Override defaults
inoremap <C-t> <Esc>
noremap <C-t> <Esc>
vnoremap p pgvy
nnoremap Y y$
nnoremap ZA :wqa<CR>

" Make J and K available for hop.nvim
noremap <leader>j J
nnoremap <silent><c-k> K

" Insert/command mode delete
inoremap <C-BS> <C-w>
inoremap <C-Del> <C-o>dE
inoremap <C-h> <C-w>
cnoremap <C-BS> <C-w>
cnoremap <C-h> <C-w>

" Quickfix
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> Q :call ToggleQuickFix()<cr>

" Open links
nnoremap gx :call system('open ' . expand('<cfile>'))<CR>

" Use <BS> and <CR> for up and down
nnoremap <BS> k
nnoremap <CR> j
onoremap <BS> k
onoremap <CR> j
vnoremap <BS> k
vnoremap <CR> j

"Shortcut to clipboard
nnoremap + "+
nnoremap ++ <nop>
vnoremap + "+
vnoremap ++ <nop>
nnoremap "" :reg<CR>

" Terminal mode
tnoremap <C-t> <C-\><C-n>

" Window navigation
nnoremap <a-m> <C-w>h
nnoremap <a-e> <C-w>k
nnoremap <a-i> <C-w>l
nnoremap <a-n> <C-w>j
nnoremap <C-w>m <C-w>H
nnoremap <C-w>e <C-w>K
nnoremap <C-w>i <C-w>L
nnoremap <C-w>n <C-w>J
nnoremap <C-w>z :wincmd o<bar>vert new<bar>vert resize 80<CR><C-w>l
nnoremap <C-w>a :wincmd o<bar>wincmd v<CR>

"buffer navigation
noremap <silent><a-,> <cmd>cp<CR>
noremap <silent><a-.> <cmd>cn<CR>
noremap <silent><C-n> <cmd>bnext<CR>
noremap <silent><C-p> <cmd>bprevious<CR>
noremap gF <cmd>wincmd v<bar>wincmd l<CR>gf
nnoremap <leader>; :e<CR>

"Search
nnoremap <leader>/ *#<cmd>setlocal hlsearch<CR>
nnoremap <leader><leader>/ <cmd>set hlsearch! hlsearch?<CR>

"Tabs
noremap <leader>tn <cmd>tabnew<CR>
noremap <leader>to <cmd>tabonly<CR>
noremap <leader>tc <cmd>tabclose<CR>

"Formatting and refactoring
nnoremap <leader>cs <cmd>setlocal spell! spell?<CR>
nnoremap <leader>% <cmd>source<CR>
nnoremap <silent><leader>f mxgggqG`x
vnoremap <silent><leader>cc :sort<CR>
nnoremap <silent><leader>cc vip:sort<CR>
nnoremap <silent><leader>w <cmd>setlocal wrap! wrap?<CR>
vnoremap <silent><leader>cl :!sort_variable_length<CR>
nnoremap <silent><leader>cl vip:!sort_variable_length<CR>

"Save
inoremap <C-s> <cmd>w<CR>
nnoremap <leader>s :mksession! Session.vim<CR>
noremap <C-s> <cmd>w<CR>

"Shell commands
noremap <leader>zx :!chmod +x %<CR>

" The terminal does not detect <C-Space>. As a solution, Alacritty sends <F24>
" when ctrl+space is pressed. By binding <C-Space> to <F24> (or <S-F12>), the
" issue is solved.
imap <F24> <C-Space>
cmap <F24> <C-Space>
nmap <F24> <C-Space>
imap <S-F12> <C-Space>
cmap <S-F12> <C-Space>
nmap <S-F12> <C-Space>
