noremap <a-g> :G<space>
noremap <a-G> :G<CR>:wincmd H<CR>}jj
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
noremap <a-D> :silent! normal gf<CR>:wincmd o<bar>G mergetool<CR>
nnoremap <leader>m <cmd>diffget //2<CR>
nnoremap <leader>i <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <leader>d<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>d<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>dd :wincmd o<CR>:G difftool --name-status
nnoremap <leader>dt :wincmd o<CR>:G difftool -y
