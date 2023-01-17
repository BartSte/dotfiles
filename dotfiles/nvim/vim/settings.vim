filetype on
let mapleader = " "
set diffopt+=vertical,iblank,closeoff
set nowrap
set textwidth=80

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
set colorcolumn=80
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
