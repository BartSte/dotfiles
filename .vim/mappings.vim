nnoremap <leader><leader>w :set fo=""<CR>:set wrap<CR>

"Insert mode mappings
execute "set <a-y>=\ey"
imap <C-BS> <C-W>
map <C-f> <Esc>
imap <C-f> <Esc>
inoremap jj <Esc>
inoremap <C-s> <NOP>
inoremap <a-y> <space>=<space>

"Save
noremap <C-s> :w<CR>

"Window navigation
nnoremap <C-w>h <C-w>H 
nnoremap <C-w>j <C-w>J  
nnoremap <C-w>k <C-w>K 
nnoremap <C-w>l <C-w>L 
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Bug in wsl -> ctrl-h sends z
nnoremap z <C-w>h

"Buffer navigation
execute "set <a-b>=\eb"
execute "set <a-B>=\eB"
nmap <a-B> <Plug>Kwbd
noremap <a-b> :Buffers<CR>
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>

execute "set <a-C>=\eC"
execute "set <a-E>=\eE"
execute "set <a-S>=\eS"
execute "set <a-V>=\eV"
execute "set <a-W>=\eW"
execute "set <a-R>=\eR"
execute "set <a-P>=\eP"
noremap <F7> :VimspectorReset<CR>
noremap <a-C> :b vimspector.Console<CR>
noremap <a-E> :b vimspector.Output:stderr<CR>
noremap <a-A> :b vimspector.StackTrace<CR>
noremap <a-V> :b vimspector.Variables<CR>
noremap <a-W> :b vimspector.Watches<CR>
noremap <a-R> :b vimspector.output:server<CR>
noremap <a-P> :VimspectorBreakpoints<CR>

"Tabbing
nnoremap <S-Tab> <<
nnoremap <Tab> >>
vnoremap <S-Tab> <gv
vnoremap <Tab> >gv

" set <F15>=[1;5I
" set <F16>=[1;6I
" nmap <F15> <C-Tab>
" nmap <F16> <C-S-Tab>
" imap <F15> <C-Tab>
" imap <F16> <C-S-Tab>


"File navigation
execute "set <a-e>=\ee"
execute "set <a-h>=\eh"
execute "set <a-o>=\eo"
noremap <a-e> :NERDTreeFocus<CR>
noremap <a-h> :NERDTreeToggle<CR>
noremap mt mT
noremap ma mA
noremap ms mS
noremap md mD
noremap mf mF
noremap 't 'T'"
noremap 'a 'A'"
noremap 's 'S'"
noremap 'd 'D'"
noremap 'f 'F'"

"Search
noremap <a-o> :GFiles<CR>
noremap <C-t> :Files<CR>
noremap <C-g> :Ag<space>
nnoremap <leader>v :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>lh

"Git
execute "set <a-g>=\eg"
execute "set <a-G>=\eG"
execute "set <a-x>=\ex"
noremap <a-g> :G<space>
noremap <a-G> :vertical G<CR>
noremap <a-x> :GV<CR>:syntax on<CR>

"Testing
execute "set <a-t>=\et"
execute "set <a-l>=\el"
execute "set <a-f>=\ef"
noremap <a-t> :only<bar>TestNearest -strategy=dispatch<bar>wincmd L<CR>
noremap <a-l> :only<bar>TestLast -strategy=dispatch<bar>wincmd L<CR>
noremap <a-f> :only<bar>TestFile -strategy=dispatch<bar>wincmd L<CR>
noremap <a-s> :only<bar>TestSuite -strategy=dispatch<bar>wincmd L<CR>

"Testing & debugging
execute "set <a-T>=\eT"
execute "set <a-L>=\eL"
execute "set <a-F>=\eF"
execute "set <a-S>=\eF"
noremap <a-T> :TestNearest -strategy=pyunit<CR>
noremap <a-L> :TestLast -strategy=pyunit<CR>
noremap <a-F> :TestFile -strategy=pyunit<CR>
noremap <a-S> :TestSuite -strategy=pyunit<CR>

"Go to shortcuts
map <leader> <Plug>(easymotion-prefix)
map gD :wincmd v<bar>wincmd l<CR>gd
noremap gl :TestVisit<CR>

"Formatting and refactoring
noremap <leader><leader>s :sort<CR>
noremap <leader>f :Format<CR>
noremap <leader>i :OR<CR>

"Tab shortcuts
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tn :tabnew<CR>

"Config file edit and load
noremap <leader><leader>vc :e ~/.vim/constants.vim<CR>
noremap <leader><leader>vf :e ~/.vim/functions.vim<CR>
noremap <leader><leader>vm :e ~/.vim/mappings.vim<CR>
noremap <leader><leader>vp :e ~/.vim/plugins.vim<CR>
noremap <leader><leader>vs :e ~/.vim/settings.vim<CR>
noremap <leader><leader>vo :e ~/.vim/colors.vim<CR>
noremap <leader><leader>vg :e ~/.gvimrc<CR>
noremap <leader><leader>% :so %<CR>

"Override default normalmode maps
noremap H ^
noremap J }
noremap K {
noremap L g_
noremap ^ H
noremap g_ L

noremap <leader><leader>k K
noremap <leader><leader>j J

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
execute "set <a-v>=\ev"
nnoremap Y y$
vnoremap p pgvy
nnoremap <C-c> "*yy
nnoremap <C-v> "*p
nnoremap <C-x> "*dd
nnoremap <a-v> "*P
vnoremap <C-c> "*y
vnoremap <C-v> "*p
vnoremap <C-x> "*d

"Quickfix
nnoremap [q :cp<CR>
nnoremap ]q :cn<CR>

"Coc
execute "set <a-k>=\ek"

map gd <Plug>(coc-definition)
map gi <Plug>(coc-implementation)
map gr <Plug>(coc-references)
map gy <Plug>(coc-type-definition)
map <leader>r <Plug>(coc-rename)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent><leader>a  <Plug>(coc-codeaction)
xmap <silent><leader>a  <Plug>(coc-codeaction-selected)
nmap <silent><leader>A  <Plug>(coc-codeaction-line)
nmap <silent><leader>q  <Plug>(coc-fix-current)
xmap <leader>f  <Plug>(coc-format-selected)
nnoremap <silent> <a-k> :call ShowDocumentation()<CR>

nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>
nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
nnoremap <silent><leader>cl <Plug>(coc-codelens-action)
nnoremap <silent><leader>cd :CocToggle<CR>

imap <silent><expr> <c-a> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : CheckBackspace() ? "\<TAB>" : coc#refresh()
inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif
