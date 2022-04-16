call plug#begin() " Colors 
Plug 'morhetz/gruvbox'
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

" Testing and debugging
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-python'}
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-test/vim-test'
call plug#end()

if has ('syntax')
    syntax on
endif

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Formatting commands
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

set autoindent
set backspace=indent,eol,start
set belloff=all
set cmdheight=2
set colorcolumn=80
set confirm
set diffopt+=vertical
set encoding=utf-8
set expandtab
set foldlevel=20
set foldmethod=indent
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
let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "
let NERDTreeShowHidden=1
let g:auto_save = 1
let g:auto_save_silent = 0
let g:auto_save_events = ["WinLeave"]
let g:python_highlight_all = 1

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

"Insert mode mappings
imap <C-BS> <C-W>
inoremap kj <Esc>
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"Save
noremap <C-s> :w<CR>

"Window navigation
noremap <C-w>h <C-w>H 
noremap <C-w>j <C-w>J  
noremap <C-w>k <C-w>K 
noremap <C-w>l <C-w>L 
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"Buffer navigation
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>
noremap <C-b> :Buffers<CR>
noremap <a-C> :b vimspector.Console<CR>
noremap <a-R> :b vimspector.output:server<CR>
noremap <a-S> :b vimspector.StackTrace<CR>
noremap <a-E> :b vimspector.Output:stderr<CR>
noremap <a-V> :b vimspector.Variables<CR>
noremap <a-W> :b vimspector.Watches<CR>

"Yanking, deleting, pasting
nnoremap Y y$
nnoremap <C-c> "*yy
nnoremap <C-v> "*p
nnoremap <C-x> "*dd
nnoremap <a-v> "*P

"Tabbing
nnoremap <S-Tab> <<
nnoremap <Tab> >>

"File navigation
noremap <a-e> :NERDTreeFocus<CR>
noremap <a-h> :NERDTreeToggle<CR>
noremap <a-o> :Files<CR>
noremap <a-O> :GFiles<CR>

"Git
noremap <a-g> :G 
noremap <a-G> :vertical G<CR>

"Testing
noremap <a-t> :TestNearest -strategy=asyncrun<bar>wincmd L<CR>
noremap <a-l> :TestLast -strategy=asyncrun<bar>wincmd L<CR>
noremap <a-f> :TestFile -strategy=asyncrun<bar>wincmd L<CR>
noremap <a-a> :TestSuite -strategy=asyncrun<bar>wincmd L<CR>

"Testing & debugging
noremap <a-T> :TestNearest -strategy=pyunit<CR>
noremap <a-L> :TestLast -strategy=pyunit<CR>
noremap <a-F> :TestFile -strategy=pyunit<CR>
noremap <a-A> :TestSuite -strategy=pyunit<CR>

"Go to shortcuts
noremap gd <Plug>(coc-definition)
noremap gl :TestVisit<CR>
noremap gi <Plug>(coc-implementation)
noremap gr <Plug>(coc-references)
noremap gy <Plug>(coc-type-definition)
noremap <leader> <Plug>(easymotion-prefix)
noremap gh <Plug>VimspectorBalloonEval
xmap gh <Plug>VimspectorBalloonEval

"Formatting and refactoring
noremap <leader><leader>s :sort<CR>
noremap <leader>f :Format<CR>
noremap <leader>i :OR<CR>
noremap <leader>r <Plug>(coc-rename)
noremap <leader><leader>j J

"Tab shortcuts
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tn :tabnew<CR>

"Config file edit and load
noremap <leader><leader>v :e ~/.vimrc<CR>
noremap <leader><leader>g :e ~/.gvimrc<CR>
noremap <leader><leader><leader>v :so ~/.vimrc<CR>
noremap <leader><leader><leader>g :so ~/.vimrc<bar>so ~/.gvimrc<CR>

"Override default normalmode maps
noremap H ^
noremap J }
noremap K {
noremap L g_
noremap ^ H
noremap g_ L

"Override default operator maps
onoremap H ^
onoremap L g_
onoremap ^ H
onoremap g_ L

"Folding
nnoremap <leader><leader>h zC
nnoremap <leader><leader>l zO
nnoremap <leader><leader>m zM
nnoremap <leader>h zc
nnoremap <leader>l zo
nnoremap <leader>m zR

"Yanking, deleting, pasting (visual mode)
vnoremap <C-c> "*y
vnoremap <C-v> "*p
vnoremap <C-x> "*d
vnoremap <S-Tab> <<
vnoremap <Tab> >>
vnoremap p pgvy

" A function that enables deleting a buffer that is currently visible is an
" active window without removing the window. It also ensure there is always 1
" (empty) buffer present to avoid vim from shutting down.
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

nmap ZZ <Plug>Kwbd

" Customize vimspector gui
function! s:CustomiseUI()
    " Change the Winbar of the code window
    call win_gotoid( g:vimspector_session_windows.code )
    nunmenu WinBar
    nnoremenu <silent>WinBar.Stop(F3) :call vimspector#Stop( { 'interactive': v:false } )<CR>
    nnoremenu <silent>WinBar.Restart(F4) :call vimspector#Restart()<CR>
    nnoremenu <silent>WinBar.Cont(F5) :call vimspector#Continue()<CR>
    nnoremenu <silent>WinBar.Break(F6) :call vimspector#Pause()<CR>
    nnoremenu <silent>WinBar.Reset(F7) :call vimspector#Reset( { 'interactive': v:false } )<CR>
    nnoremenu <silent>WinBar.Next(F10) :call vimspector#StepOver()<CR>
    nnoremenu <silent>WinBar.Step(F11) :call vimspector#StepInto()<CR>
    nnoremenu <silent>WinBar.Out(F12) :call vimspector#StepOut()<CR>
    
    " Creat 1 output window for the other buffers.
    only
    vsplit
    nnoremenu <silent>WinBar.Console :b vimspector.Console<CR>
    nnoremenu <silent>WinBar.Errors :b vimspector.Output:stderr<CR>
    nnoremenu <silent>WinBar.Server :b vimspector.output:server<CR>
    nnoremenu <silent>WinBar.Stack :b vimspector.StackTrace<CR>
    nnoremenu <silent>WinBar.Variables :b vimspector.Variables<CR>
    nnoremenu <silent>WinBar.Watches :b vimspector.Watches<CR>
    b vimspector.Output:stderr
endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END
