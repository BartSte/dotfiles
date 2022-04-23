call plug#begin()
" Aestatics 
Plug 'morhetz/gruvbox'
Plug 'k4yt3x/ayu-vim-darker'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'vim-python/python-syntax'

" Search, linting, and autocomplete
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'frazrepo/vim-rainbow'
Plug 'preservim/nerdtree'

" Typing
Plug '907th/vim-auto-save'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Source control
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'

" Testing and debugging
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-python'}
Plug 'tpope/vim-dispatch'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-test/vim-test'
call plug#end()

