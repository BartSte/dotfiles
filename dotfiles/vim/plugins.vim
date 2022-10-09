call plug#begin()
" Looks
Plug 'ellisonleao/gruvbox.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-python/python-syntax'
Plug 'frazrepo/vim-rainbow'
Plug 'machakann/vim-highlightedyank'

" Search, linting, and autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Navigation
Plug 'phaazon/hop.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" Editing
Plug '907th/vim-auto-save'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'chrisbra/csv.vim'

" Source control
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'

" Testing and debugging
Plug 'puremourning/vimspector'
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'

call plug#end()
