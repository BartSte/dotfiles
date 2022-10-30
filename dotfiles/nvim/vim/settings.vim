let mapleader = " "
let g:highlightedyank_highlight_duration = 150

" Miscelaneous
set belloff=all
set diffopt+=vertical,iblank,closeoff
set history=1000
set tabpagemax=50
set nocompatible
set notimeout
set shortmess=at

" Recommended by Coc
set hidden
set nobackup
set noswapfile
set nowritebackup
set encoding=utf-8
set updatetime=500
set signcolumn=no

" Tabbing
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=4

" Editor features
filetype on
set colorcolumn=80
set cursorline
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=20
set foldmethod=expr
set foldmethod=indent
set laststatus=2
set mouse=a
set nostartofline
set number
set relativenumber
set scrolloff=999
set sidescrolloff=5

" Command line
set showcmd
set wildmenu
set noshowmode
set pumheight=10
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set completeopt=menu

" Searching
set incsearch
set smartcase
set ignorecase

" Formatting
set nowrap
set textwidth=80
set formatoptions-=tc
