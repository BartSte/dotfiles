call plug#begin()
" Looks
Plug 'sainnhe/gruvbox-material'
Plug 'frazrepo/vim-rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'vim-python/python-syntax'

" Lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'phaazon/hop.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'moll/vim-bbye'

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
