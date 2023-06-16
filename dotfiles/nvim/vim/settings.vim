filetype on

let mapleader = " "
set diffopt+=vertical,iblank,closeoff
set nowrap

" Completion
set pumheight=10
set pumwidth=15

" Backup
set noswapfile
set nowritebackup

" Updates
set notimeout
set updatetime=500

" Looks
set signcolumn=number
set cursorline
set number
set relativenumber

" Tabbing
set autoindent
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=4

" Folding
set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Command line
set showcmd
set cmdheight=1
set cedit=\<C-t>
set nowildmenu

" Searching
set smartcase
set ignorecase
set nohlsearch

" Spell
set nospell
set spelllang=en,nl

"alt mappings a re for moving out of the editor -> alt==appear
"leader mappings are for text editing.
"control mappings are kept at the default where possible, e.g., fzf's <C-t>

" Powershell does not detect <C-Space>. As a solution, Alacritty sends <F24> 
" when ctrl+space is pressed. By binding <C-Space> and <F24>, the issue is
" solved.

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

imap <F24> <C-Space>
cmap <F24> <C-Space>
nmap <F24> <C-Space>
imap <S-F12> <C-Space>
cmap <S-F12> <C-Space>
nmap <S-F12> <C-Space>

"Insert mode 
inoremap <C-BS> <C-w>
inoremap <C-h> <C-w>
inoremap <C-Del> <C-o>dE
inoremap <C-t> <Esc>
inoremap <C-s> <C-o><cmd>w<CR>

" Command mode
cnoremap <C-BS> <C-w>
cnoremap <C-h> <C-w>

"Shortcut to clipboard
nnoremap + "+
nnoremap ++ <nop>
vnoremap + "+
vnoremap ++ <nop>

"Override default mappings
nnoremap <BS> k
nnoremap <CR> j
nnoremap <silent><c-k> K
nnoremap Y y$
nnoremap ZA :wqa<CR>
noremap <C-s> <cmd>w<CR>
noremap <C-t> <Esc>
noremap <leader>j J
onoremap <BS> k
onoremap <CR> j
vnoremap <BS> k
vnoremap <CR> j
vnoremap p pgvy
nnoremap <silent> Q :call ToggleQuickFix()<cr>

" Terminal mode
tnoremap <C-t> <C-\><C-n>

" Window navigation
nnoremap <a-e> <C-w>k
nnoremap <a-m> <C-w>h
nnoremap <a-i> <C-w>l
nnoremap <a-n> <C-w>j
nnoremap <C-w>m <C-w>H 
nnoremap <C-w>e <C-w>K 
nnoremap <C-w>i <C-w>L 
nnoremap <C-w>n <C-w>J  

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
nnoremap <leader>s <cmd>setlocal spell! spell?<CR>
nnoremap <leader>% <cmd>source<CR>
nnoremap <silent><leader>f mxgggqG`x
vnoremap <silent><leader>cc :sort<CR>
nnoremap <silent><leader>cc vip:sort<CR>
nnoremap <silent><leader>w <cmd>setlocal wrap! wrap?<CR>
vnoremap <silent><leader>cl :!sort_variable_length.py<CR>
nnoremap <silent><leader>cl vip:!sort_variable_length.py<CR>
