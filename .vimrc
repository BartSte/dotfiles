call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-python'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'itchyny/lightline.vim'
Plug '907th/vim-auto-save'
call plug#end()

if has ('syntax')
    syntax on
endif

if has('mouse')
    set mouse=a
endif

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

colorscheme gruvbox
highlight Normal guibg=black

set autoindent
set backspace=indent,eol,start
set belloff=all
set cmdheight=2
set colorcolumn=80
set confirm
set encoding=utf-8
set expandtab
set foldlevel=20
set foldmethod=indent
set guifont=Consolas:h11:cANSI
set guioptions-=T
set guioptions-=m
set guioptions-=r
set hidden
set ignorecase
set incsearch
set laststatus=2
set modifiable
set nostartofline
set notimeout ttimeout ttimeoutlen=200
set number
set pastetoggle=<F11>
set relativenumber
set scrolloff=999
set shiftwidth=4
set shortmess+=c
set showcmd
set noshowmode
set smartcase
set statusline=%{FugitiveStatusline()}
set softtabstop=4
set termguicolors
set textwidth=80
set updatetime=300
set wildmenu

function! PyUnitTestStrategy(cmd)
  let testName = split(a:cmd)[-1]
  call vimspector#LaunchWithSettings( #{ configuration: 'pyunit', TestName: testName } )
endfunction

let g:test#custom_strategies = {'pyunit': function('PyUnitTestStrategy')}
let g:rainbow_active = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:test#preserve_screen = 1
let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "
let NERDTreeShowHidden=1
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave"]

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

imap <C-BS> <C-W>
inoremap kj <Esc>
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

noremap <C-s> :w<CR>

noremap <C-w>h <C-w>H 
noremap <C-w>j <C-w>J  
noremap <C-w>k <C-w>K 
noremap <C-w>l <C-w>L 
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>
noremap <C-b> :Buffers<CR>

nnoremap Y y$
nnoremap <C-c> "*yy
nnoremap <C-v> "*p
nnoremap <C-x> "*dd
nnoremap <a-v> "*P

nnoremap <S-Tab> <<
nnoremap <Tab> >>

noremap <a-e> :NERDTreeFocus<CR>
noremap <a-h> :NERDTreeToggle<CR>
noremap <a-o> :GFiles<CR>
noremap <a-O> :Files<CR>

noremap <a-g> :G<CR>

noremap <a-t> :TestNearest -strategy=dispatch<cr>
noremap <a-l> :testlast -strategy=dispatch<CR>
noremap <a-f> :TestFile -strategy=dispatch<CR>
noremap <a-s> :TestSuite -strategy=dispatch<CR>

noremap <a-T> :TestNearest -strategy=pyunit<CR>
noremap <a-L> :TestLast -strategy=pyunit<CR>
noremap <a-F> :TestFile -strategy=pyunit<CR>
noremap <a-S> :TestSuite -strategy=pyunit<CR>

noremap gd <Plug>(coc-definition)
noremap gl :TestVist<CR>
noremap gi <Plug>(coc-implementation)
noremap gr <Plug>(coc-references)
noremap gy <Plug>(coc-type-definition)

noremap <leader><leader>s :sort<CR>
noremap <leader>f :Format<CR>
noremap <leader>i :OR<CR>
noremap <leader>r <Plug>(coc-rename)
noremap <leader><leader>j J

noremap <leader> <Plug>(easymotion-prefix)
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader><leader>v :e ~/.vimrc<CR>

noremap H ^
noremap J }
noremap K {
noremap L g_
noremap ^ H
noremap g_ L

onoremap H ^
onoremap L g_
onoremap ^ H
onoremap g_ L

nnoremap <leader><leader>h zC
nnoremap <leader><leader>l zO
nnoremap <leader><leader>m zM
nnoremap <leader>h zc
nnoremap <leader>l zo
nnoremap <leader>m zR

vnoremap <C-c> "*y
vnoremap <C-v> "*p
vnoremap <C-x> "*d
vnoremap <S-Tab> <<
vnoremap <Tab> >>
vnoremap p pgvy

