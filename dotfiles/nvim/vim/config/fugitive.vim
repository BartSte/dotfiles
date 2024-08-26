noremap <a-g> :G<space>
noremap <a-G> :G<CR>:wincmd H<CR>}jj
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
noremap <a-D> :silent! normal gf<CR>:wincmd o<bar>G mergetool<CR>

nnoremap <leader>gm <cmd>diffget //2<CR>
nnoremap <leader>gi <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <leader>g<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>g<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>gd :wincmd o<CR>:G difftool --name-status 
nnoremap <leader>gy :G difftool -y 
nnoremap <leader>gs :G switch 
nnoremap <leader>gt :G switch -t origin/
nnoremap <leader>gf :G fetch<CR>
nnoremap <leader>gp :G pull<CR>
nnoremap <leader>gu :G push<CR>
nnoremap <leader>gU :G push -f
nnoremap <leader>ge :G merge 
nnoremap <leader>gr :G rebase 
