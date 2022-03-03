set shellslash
set rtp+=~/vimfiles/bundle/Vundle.vim

call vundle#begin('~/vimfiles/bundle')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-surround'
Plugin 'dracula/vim', {'name':'dracula'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" Put your non-Plugin stuff after this line

if has ('syntax')
    syntax on
endif
if has('mouse')
    set mouse=a
endif

colorscheme dracula
highlight Normal guibg=black guifg=white

set encoding=utf-8
set fileencoding=utf-8
set number
set relativenumber
set scrolloff=999
set incsearch
set showcmd
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set shiftwidth=4
set softtabstop=4
set expandtab
set guifont=Consolas:h11:cANSI
set hidden
set wildmenu
set laststatus=2
set confirm
set visualbell
set t_vb=
set cmdheight=1
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set guioptions-=m
set guioptions-=T
set guioptions-=r

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let mapleader = " "

map K {
map J }
map <Leader> <Plug>(easymotion-prefix)
map <C-s> :w<CR>

inoremap kj <Esc>

noremap <leader><leader>j J
noremap H ^
noremap ^ H
noremap L g_
noremap g_ L

nmap Y y$
nmap <Tab> >>
nmap <S-Tab> <<
nmap <leader>h zc
nmap <leader><leader>h zC
nmap <leader>l zo
nmap <leader><leader>l zO
nmap <C-w> ZZ
nmap <C-v> "*p
nmap <C-V> "*P
nmap <C-c> "*yy
nmap <C-x> "*dd

vnoremap p pgvy
vnoremap <C-v> "*p
vnoremap <C-c> "*y
vnoremap <C-x> "*d

onoremap K {
onoremap J }
onoremap H ^
onoremap ^ H
onoremap L g_
onoremap g_ L
