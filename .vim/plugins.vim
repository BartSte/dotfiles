call plug#begin()
" Looks
Plug 'frazrepo/vim-rainbow'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'k4yt3x/ayu-vim-darker'
Plug 'vim-python/python-syntax'

" Search, linting, and autocomplete
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdtree'

" Editing
Plug '907th/vim-auto-save'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Source control
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'

" Testing and debugging
Plug 'puremourning/vimspector'
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'
call plug#end()

