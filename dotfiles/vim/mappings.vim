"alt mappings a re for moving out of the editor -> alt==appear
"leader mappings are for text editing.
"control mappings are kept at the default where possible, e.g., fzf's <C-t>

"Insert mode 
inoremap <C-BS> <C-W>
inoremap <C-h> <C-W>

inoremap <C-Del> <C-o>dE
inoremap <C-t> <Esc>
inoremap <C-s> <C-o>:w<CR>

"Override default mappings
onoremap <CR> j
onoremap <BS> k
nnoremap <CR> j
nnoremap <BS> k
nnoremap Y y$
noremap <C-s> :w<CR>
vnoremap p pgvy
nnoremap <leader>j J
" nnoremap <C-d> 10j
" nnoremap <C-u> 10k
" nnoremap [6~ <C-d>
" nnoremap [5~ <C-u>
" nnoremap <PageDown> <C-d>
" nnoremap <PageUp> <C-u>

" Terminal mode
tnoremap <C-t> <C-\><C-n>
map <a-q> <cmd>wincmd v<bar>term<CR>mQ
map <a-Q> <cmd>only<bar>wincmd v<bar>term<CR>mQ

" Window navigation
nnoremap <C-w>m <C-w>H 
nnoremap <C-w>n <C-w>J  
nnoremap <C-w>e <C-w>K 
nnoremap <C-w>i <C-w>L 
nnoremap <a-e> <C-w>k
nnoremap <a-m> <C-w>h
nnoremap <a-i> <C-w>l
nnoremap <a-n> <C-w>j

"buffer navigation
nmap ZB <Plug>Kwbd
noremap 'a 'A'"
noremap 'd 'D'"
noremap 's 'S'"
noremap 't 'T'"
noremap 'q 'Q'"
noremap <silent><C-n> :bnext<CR>
noremap <silent><C-p> :bprevious<CR>
noremap <silent><a-X> :NvimTreeFindFile<CR>
noremap <silent><a-b> :Buffers<CR>
noremap <silent><a-x> :NvimTreeToggle<CR>
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
noremap <a-a> :Ag<space>
nnoremap <leader>/ *#:set hlsearch<CR>

"Git
noremap <a-g> :G<space>
noremap <a-G> :vertical G<CR>'"
noremap <a-z> :GV<CR>:syntax on<CR>
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>

"Testing & debugging
noremap gl :TestVisit<CR>
noremap <a-t> :only<bar>TestNearest -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-s> :only<bar>TestLast -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-f> :only<bar>TestFile -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-S> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>

"Tabs
noremap <leader><leader>tc :tabclose<CR>
noremap <leader><leader>to :tabonly<CR>
noremap <leader><leader>tn :tabnew<CR>

"Config file edit and load
" noremap <leader>vc :e ~/dotfiles/vim/constants.vim<CR>
" noremap <leader>vf :e ~/dotfiles/vim/functions.vim<CR>
" noremap <leader>vm :e ~/dotfiles/vim/mappings.vim<CR>
" noremap <leader>vp :e ~/dotfiles/vim/plugins.vim<CR>
" noremap <leader>vs :e ~/dotfiles/vim/settings.vim<CR>
" noremap <leader>vo :e ~/dotfiles/vim/colors.vim<CR>
" noremap <leader>vi :e ~/dotfiles/vim/init.vim<CR>
" noremap <leader>vg :e ~/dotfiles/vim/ginit.vim<CR>
" noremap <leader>vv :e ~/.vimrc<CR>
" noremap <leader>vx :e ~/.gvimrc<CR>
noremap <a-v> <cmd>Files ~/dotfiles/vim<CR>
noremap <leader>% :so %<CR>

"Formatting and refactoring
noremap <silent><leader>p :setlocal wrap! wrap?<CR>
noremap <silent><leader>cc vip:sort<CR>
noremap <silent><leader>cl vip:!sort_variable_length<CR>
vnoremap <silent><leader>cc :sort<CR>
vnoremap <silent><leader>cl :!sort_variable_length<CR>

