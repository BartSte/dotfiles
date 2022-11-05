let mapleader = " "

" Miscelaneous
set diffopt+=vertical,iblank,closeoff
set notimeout
set noswapfile
set nowritebackup
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
set number
set relativenumber
set scrolloff=999

" Folding
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=20
set foldmethod=expr

" Command line
set showcmd
set nowildmenu
set wildmenu

" Searching
set smartcase
set ignorecase
set nohlsearch

" Formatting
set nowrap
set textwidth=80
