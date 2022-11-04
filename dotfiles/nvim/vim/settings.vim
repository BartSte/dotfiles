let mapleader = " "

" Miscelaneous
set belloff=all
set diffopt+=vertical,iblank,closeoff
set history=1000
set tabpagemax=50
set notimeout
set shortmess=at
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
set laststatus=2
set mouse=a
set nostartofline
set number
set relativenumber
set scrolloff=999
set sidescrolloff=5

" Folding
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=20
set foldmethod=expr

" Command line
set showcmd
set pumheight=10
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Searching
set smartcase
set ignorecase
set nohlsearch

" Formatting
set nowrap
set textwidth=80
