"alt mappings a re for moving out of the editor -> alt==appear
"leader mappings are for text editing.
"control mappings are kept at the default where possible, e.g., fzf's <C-t>

"Insert mode 
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-o>dE
inoremap <C-t> <Esc>
inoremap <C-h> <C-W>
inoremap <C-s> <NOP>
inoremap <S-Tab> <BS>

"Override default mappings
nnoremap Y y$
noremap <C-s> :w<CR>
vnoremap <S-Tab> <gv
vnoremap <Tab> >gv
vnoremap p pgvy
nnoremap <C-d> 10j
nnoremap <C-u> 10k
nnoremap [6~ <C-d>
nnoremap [5~ <C-u>
nnoremap <PageDown> <C-d>
nnoremap <PageUp> <C-u>

"Easymotion
map <Leader> <Plug>(easymotion-prefix)
map <leader><leader>w <Plug>(easymotion-bd-w)
map <leader>a <Plug>(easymotion-jumptoanywhere)
map <leader>d <Plug>(easymotion-j)
map <leader>l <Plug>(easymotion-bd-jk)
map <leader>s <Plug>(easymotion-bd-f)
map <leader>u <Plug>(easymotion-k)
nmap <leader><leader>w <Plug>(easymotion-overwin-w)
nmap <leader>l <Plug>(easymotion-overwin-line)
nmap <leader>s <Plug>(easymotion-overwin-f)

" Window navigation
nnoremap <C-w>m <C-w>H 
nnoremap <C-w>n <C-w>J  
nnoremap <C-w>e <C-w>K 
nnoremap <C-w>l <C-w>L 
nnoremap <a-e> <C-w>k
nnoremap <a-m> <C-w>h
nnoremap <a-l> <C-w>l
nnoremap <a-n> <C-w>j

"Buffer navigation
nmap ZB <Plug>Kwbd
nmap gD :wincmd v<bar>wincmd l<CR>gd
nmap gd <Plug>(coc-definition)
nmap gr <Plug>(coc-references)
nmap gy <Plug>(coc-type-definition)
noremap 'a 'A'"
noremap 'd 'D'"
noremap 's 'S'"
noremap 't 'T'"
noremap <silent><C-n> :bnext<CR>
noremap <silent><C-p> :bprevious<CR>
noremap <silent><a-X> :NERDTreeFind<CR>
noremap <silent><a-b> :Buffers<CR>
noremap <silent><a-x> :NERDTreeToggle<CR>
noremap <silent><a-,> :cp<CR>
noremap <silent><a-.> :cn<CR>
noremap ma mA
noremap md mD
noremap ms mS
noremap mt mT

"Vimspector
noremap <F7> :VimspectorReset<CR>
noremap <a-C> :b vimspector.Console<CR>
noremap <a-E> :b vimspector.Output:stderr<CR>
noremap <a-A> :b vimspector.StackTrace<CR>
noremap <a-V> :b vimspector.Variables<CR>
noremap <a-W> :b vimspector.Watches<CR>
noremap <a-R> :b vimspector.output:server<CR>
noremap <a-P> :VimspectorBreakpoints<CR>

"Search
noremap <a-o> :Files<CR>
noremap <C-a> :Ag<space>
nnoremap <leader>/ *#:set hlsearch<CR>
nnoremap <leader><leader>/ :set hlsearch! hlsearch?<CR>

"Git
noremap <a-g> :G<space>
noremap <a-G> :vertical G<CR>'"
noremap <a-z> :GV<CR>:syntax on<CR>
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>

"Testing & debugging
noremap gl :TestVisit<CR>
noremap <a-t> :only<bar>TestNearest -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-s> :only<bar>TestLast -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-f> :only<bar>TestFile -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-S> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>

"Tabs
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>

"Config file edit and load
noremap <leader>vc :e ~/.vim/constants.vim<CR>
noremap <leader>vf :e ~/.vim/functions.vim<CR>
noremap <leader>vm :e ~/.vim/mappings.vim<CR>
noremap <leader>vp :e ~/.vim/plugins.vim<CR>
noremap <leader>vs :e ~/.vim/settings.vim<CR>
noremap <leader>vo :e ~/.vim/colors.vim<CR>
noremap <leader>vv :e ~/.vimrc<CR>
noremap <leader>vg :e ~/.gvimrc<CR>
noremap <leader>% :so %<CR>

"Formatting and refactoring
inoremap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent><C-p> <C-r>=CocActionAsync('showSignatureHelp')<CR>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-@> coc#refresh()

nmap <leader>r <Plug>(coc-rename)
nmap <leader>cd <Plug>(coc-action-toggleDiagnosticsBuffer)
nmap <silent> <a-c> :CocDiagnostics<CR>
nmap <silent><a-k> :call ShowDocumentation()<CR>
nmap <silent><leader>ca <Plug>(coc-codeaction-line)
nmap <silent><leader>cq <Plug>(coc-fix-current)
noremap <silent><leader><BS> :Format<CR>
noremap <silent><leader>cc vip:sort<CR>
noremap <silent><leader>cl vip:!sort_variable_length<CR>
noremap <silent><leader>i :OR<CR>
noremap <silent><leader>p :setlocal wrap! wrap?<CR>

vnoremap <silent><leader>cc :sort<CR>
vnoremap <silent><leader>cl :!sort_variable_length<CR>
xmap <silent><leader>ca <Plug>(coc-codeaction-selected)
xmap <silent><leader><BS> <Plug>(coc-format-selected)
xnoremap <C-l> <Plug>(coc-convert-snippet)
