" Recommended by Coc
set hidden
set nobackup
set noswapfile
set nowritebackup
set encoding=utf-8
set shortmess+=c
set updatetime=1000
set signcolumn=number

" Miscelaneous
set notimeout
set modifiable
set nocompatible
set belloff=all
set history=500
set diffopt+=vertical

" Tabbing
set expandtab
set autoindent
set backspace=indent,eol,start
set shiftwidth=4
set softtabstop=4

" Editor features
filetype on
set number
set nostartofline
set relativenumber
set mouse=a
set foldlevel=20
set scrolloff=999
set laststatus=2
set foldmethod=indent
set colorcolumn=80
if &term != "win32"
    set cursorline
endif

" Command line
set showcmd
set wildmenu
set noshowmode
set pumheight=10
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set completeopt=menu
set wildoptions=pum,fuzzy

" Searching
set incsearch
set smartcase
set ignorecase

" Formatting
set nowrap
set textwidth=80
