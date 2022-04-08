call plug#begin()

Plug 'easymotion/vim-easymotion'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-python'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'mhinz/vim-startify'

call plug#end()

if has ('syntax')
    syntax on
endif

if has('mouse')
    set mouse=a
endif

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

autocmd TextChanged,TextChangedI <buffer> silent write
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

colorscheme gruvbox
highlight Normal guibg=black guifg=white

set textwidth=80
set autoindent
set backspace=indent,eol,start
set belloff=all
set cmdheight=2
set confirm
set colorcolumn=80
set encoding=utf-8
set expandtab
set foldmethod=indent
set foldlevel=20
set fileencoding=utf-8
set guifont=Consolas:h11:cANSI
set guioptions-=T
set guioptions-=m
set guioptions-=r
set hidden
set ignorecase
set incsearch
set laststatus=2
set modifiable
set nostartofline
set notimeout ttimeout ttimeoutlen=200
set number
set pastetoggle=<F11>
set relativenumber
set ruler
set rulerformat=%=%P
set scrolloff=999
set shiftwidth=4
set shortmess+=c
set showcmd
set smartcase
set softtabstop=4
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{FugitiveStatusline()}
set updatetime=300
set wildmenu

let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"
let g:rainbow_active = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "

map <leader><leader>s :sort<CR>
noremap <C-j> <C-W>j
noremap <C-l> <C-W>l
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-W>j <C-W>J  
noremap <C-W>l <C-W>L 
noremap <C-W>k <C-W>K 
noremap <C-W>h <C-W>H 
imap <C-BS> <C-W>
inoremap kj <Esc>
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <leader>f :Format<CR>
nmap <leader>i :OR<CR>
nmap <leader>r <Plug>(coc-rename)
nmap gd <Plug>(coc-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nmap gy <Plug>(coc-type-definition)

nnoremap <C-c> "*yy
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <C-v> "*p
nnoremap <C-x> "*dd
nnoremap <S-Tab> <<
nnoremap <Tab> >>
nnoremap <a-e> :NERDTreeFocus<CR>
nnoremap <a-h> :NERDTreeToggle<CR>
nnoremap <a-o> :GFiles<CR>
nnoremap <a-O> :Files<CR>
nnoremap <a-v> "*P
nnoremap <leader><leader>h zC
nnoremap <leader><leader>l zO
nnoremap <leader><leader>m zM
nnoremap <leader>h zc
nnoremap <leader>l zo
nnoremap <leader>m zR
nnoremap Y y$

noremap <C-s> :w<CR>
noremap <leader> <Plug>(easymotion-prefix)
noremap <leader><leader>j J
noremap <leader>v :vsplit<CR>
noremap <leader><leader>v :split<CR>

noremap H ^
noremap J }
noremap K {
noremap L g_
noremap ^ H
noremap g_ L

onoremap H ^
onoremap L g_
onoremap ^ H
onoremap g_ L

vnoremap <C-c> "*y
vnoremap <C-v> "*p
vnoremap <C-x> "*d
vnoremap <S-Tab> <<
vnoremap <Tab> >>
vnoremap p pgvy
