" Syntax highlighting
syntax on
filetype on
filetype plugin on
filetype indent on 
colorscheme ayu
set termguicolors

" Tabbing
set autoindent
set expandtab
set nostartofline
set shiftwidth=4
set softtabstop=4

" Editor features
set colorcolumn=80
set cursorline
set foldlevel=20
set foldmethod=indent
set laststatus=2
set number
set scrolloff=999
set signcolumn=number
set statusline=%{FugitiveStatusline()}
set shortmess+=c
set relativenumber
set textwidth=80

" Command line
set cmdheight=2
set noshowmode
set showcmd
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildmenu
set wildmode=list:longest

" Searching
set ignorecase
set incsearch
set smartcase
"
" Keymaps
set backspace=indent,eol,start
set pastetoggle=<F11>

" Miscelaneous
set belloff=all
set diffopt+=vertical
set hidden
set history=500
set modifiable
set nocompatible
set notimeout ttimeout ttimeoutlen=200
set updatetime=300
