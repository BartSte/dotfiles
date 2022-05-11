" Miscelaneous
set belloff=all
set diffopt+=vertical
set hidden
set history=500
set modifiable
set nocompatible
set notimeout ttimeout ttimeoutlen=200

" Tabbing
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set softtabstop=4

" Editor features
filetype on
set colorcolumn=80
set foldlevel=20
set foldmethod=indent
set laststatus=2
set nostartofline
set number
set scrolloff=999
set signcolumn=number
set relativenumber

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

" Formatting
set nowrap
set textwidth=80
set fo=""

if has("win32")
    set nocursorline "Bug in windows
else
    set cursorline
endif

