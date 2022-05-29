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
noremap <F7> :VimspectorReset<CR>
noremap <a-C> :b vimspector.Console<CR>
noremap <a-E> :b vimspector.Output:stderr<CR>
noremap <a-S> :b vimspector.StackTrace<CR>
noremap <a-V> :b vimspector.Variables<CR>
noremap <a-W> :b vimspector.Watches<CR>
noremap <a-R> :b vimspector.output:server<CR>

"Tabbing
nnoremap <S-Tab> <<
nnoremap <Tab> >>
vnoremap <S-Tab> <gv
vnoremap <Tab> >gv

"File navigation
execute "set <a-e>=\ee"
execute "set <a-h>=\eh"
execute "set <a-o>=\eo"
noremap <a-e> :NERDTreeFocus<CR>
noremap <a-h> :NERDTreeToggle<CR>
noremap ma mA
noremap ms mS
noremap md mD
noremap mf mF
noremap 'a 'A'"
noremap 's 'S'"
noremap 'd 'D'"
noremap 'f 'F'"

"Search
noremap <a-o> :GFiles<CR>
noremap <C-t> :Files<CR>
noremap <C-a> :Ag<space>
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

"Testing & debugging
execute "set <a-T>=\eT"
execute "set <a-L>=\eL"
execute "set <a-F>=\eF"
noremap <a-T> :TestNearest -strategy=pyunit<CR>
noremap <a-L> :TestLast -strategy=pyunit<CR>
noremap <a-F> :TestFile -strategy=pyunit<CR>

"Go to shortcuts
map <leader> <Plug>(easymotion-prefix)
map gd <Plug>(coc-definition)
map gD :wincmd v<bar>wincmd l<CR>gd
map gi <Plug>(coc-implementation)
map gr <Plug>(coc-references)
map gy <Plug>(coc-type-definition)
imap <silent><expr> <c-space> coc#refresh()
nmap <silent> <leader>a <Plug>(coc-codeaction-line)
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> <leader>A <Plug>(coc-codeaction)
noremap gl :TestVisit<CR>

"Formatting and refactoring
map <leader>r <Plug>(coc-rename)
" nmap <leader>d :Docstring<CR>
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
