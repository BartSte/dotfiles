source ~/.vim/alt.vim

"Insert mode mappings
inoremap <C-h> <C-W>
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-o>dE
inoremap <C-f> <Esc>
inoremap <C-s> <NOP>

"Override default mappings
noremap H ^
noremap J :keepjumps normal! }<cr>
noremap K :keepjumps normal! {<cr>
noremap L g_
noremap ^ H
noremap g_ L
noremap <C-s> :w<CR>
noremap <leader>o J

nnoremap <C-;> <C-i>
nnoremap <S-Tab> <<
nnoremap <Tab> >>
vnoremap <S-Tab> <gv
vnoremap <Tab> >gv

onoremap H ^
onoremap L g_
onoremap ^ H
onoremap g_ L

nnoremap Y y$
vnoremap p pgvy

"Navigation
map <Leader> <Plug>(easymotion-prefix)

map <leader>a <Plug>(easymotion-jumptoanywhere)
map <leader>s <Plug>(easymotion-bd-f)
map <leader>l <Plug>(easymotion-bd-jk)
map <leader><leader>w <Plug>(easymotion-bd-w)

nmap <leader>s <Plug>(easymotion-overwin-f)
nmap <leader>l <Plug>(easymotion-overwin-line)
nmap <leader><leader>w <Plug>(easymotion-overwin-w)

map gD :wincmd v<bar>wincmd l<CR>gd
noremap gl :TestVisit<CR>
nnoremap <C-w>h <C-w>H 
nnoremap <C-w>j <C-w>J  
nnoremap <C-w>k <C-w>K 
nnoremap <C-w>l <C-w>L 
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Buffer navigation
map <silent><a-b> <Plug>Kwbd
noremap <C-b> :Buffers<CR>
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>

"Vimspector
noremap <F7> :VimspectorReset<CR>
noremap <a-C> :b vimspector.Console<CR>
noremap <a-E> :b vimspector.Output:stderr<CR>
noremap <a-A> :b vimspector.StackTrace<CR>
noremap <a-V> :b vimspector.Variables<CR>
noremap <a-W> :b vimspector.Watches<CR>
noremap <a-R> :b vimspector.output:server<CR>
noremap <a-P> :VimspectorBreakpoints<CR>

"File navigation
noremap <a-e> :NERDTreeFocus<CR>
noremap <a-h> :NERDTreeToggle<CR>
noremap <a-j> :NERDTreeFind<CR>
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
noremap <C-t> :Files<CR>
noremap <C-g> :Ag<space>
nnoremap <leader>/ *#:set hlsearch<CR>
nnoremap <leader><leader>/ :set hlsearch! hlsearch?<CR>

"Git
noremap <a-g> :G<space>
noremap <a-G> :vertical G<CR>
noremap <a-x> :GV<CR>:syntax on<CR>

"Testing
noremap <a-t> :only<bar>TestNearest -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-l> :only<bar>TestLast -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-f> :only<bar>TestFile -strategy=dispatch -v<bar>wincmd L<CR>
noremap <a-s> :only<bar>TestSuite -strategy=dispatch -v<bar>wincmd L<CR>

"Testing & debugging
noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-L> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>
noremap <a-S> :TestSuite -strategy=unittest<CR>

"Formatting and refactoring
noremap <leader>cc vip:sort<CR>
vnoremap <leader>cc :sort<CR>
noremap <leader>cl vip:!sort_variable_length<CR>
vnoremap <leader>cl :!sort_variable_length<CR>
noremap <leader><BS> :Format<CR>
noremap <leader>i :OR<CR>

"Tab shortcuts
noremap <leader><leader>tn :tabnew<CR>
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>
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

"Quickfix
nnoremap { :cp<CR>
nnoremap } :cn<CR>

"Coc
inoremap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent> <C-p> <C-r>=CocActionAsync('showSignatureHelp')<CR>
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() 
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

map <leader>r <Plug>(coc-rename)
map gd <Plug>(coc-definition)
map gi <Plug>(coc-implementation)
map gr <Plug>(coc-references)
map gy <Plug>(coc-type-definition)
nmap <silent><leader>ca <Plug>(coc-codeaction-line)
nmap <silent><leader>cq <Plug>(coc-fix-current)
nmap <leader>cd <Plug>(coc-action-toggleDiagnosticsBuffer)

nmap <silent> <a-c> :CocDiagnostics<CR>
nnoremap <silent> <a-k> :call ShowDocumentation()<CR>

xmap <silent><leader>f  <Plug>(coc-format-selected)
xmap <silent><leader>ca <Plug>(coc-codeaction-selected)
xnoremap <C-l> <Plug>(coc-convert-snippet)

" Toggle line wrap
noremap <silent> <leader>cw :setlocal fo=""<CR>:setlocal wrap! wrap?<CR>

" In powershell, <C-h> sends `Îz'. As a workaround, F13 is assigned to this
" sequence. <C-Delete> should delete the wordt in front (Linux). In windows
" <C-Delete> sends only Î, so it cannot be mapped. Therefore I choose <C-d> for
" this in stead of <C-Delete>.
execute "set <F13>=\xce\x7a"
inoremap <F13> <C-W>
nnoremap <F13> <C-w>h
inoremap <a-d> <C-o>dE
