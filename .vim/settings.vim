" Syntax highlighting
syntax on
filetype on
filetype plugin on
filetype indent on 
colorscheme ayu
set termguicolors

" Tabbing
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set softtabstop=4

" Editor features
set colorcolumn=80
set foldlevel=20
set foldmethod=indent
set laststatus=2
set nostartofline
set number
set scrolloff=999
set signcolumn=number
set relativenumber

" Formatting
set nowrap
set textwidth=80
set fo=""

" Command line
set cmdheight=2
set noshowmode
set showcmd
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildmenu
set wildmode=list,full

" Searching
set incsearch
set ignorecase
set smartcase

" Miscelaneous
set belloff=all
set diffopt+=vertical
set hidden
set history=500
set modifiable
set nocompatible
set notimeout ttimeout ttimeoutlen=200
set updatetime=1000

if has("win32")
    set nocursorline "Bug in windows
else
    set cursorline
endif

