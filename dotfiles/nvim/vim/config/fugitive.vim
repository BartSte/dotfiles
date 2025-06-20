nnoremap <leader>gD :Gvdiffsplit<space>
nnoremap <leader>gT :G push --tags -f
nnoremap <leader>gU :G push -f
nnoremap <leader>ge :G merge<space>
nnoremap <leader>gr :G rebase<space>
nnoremap <leader>gs :G switch<space>
nnoremap <silent><leader>G :G<CR>:wincmd H<CR>}<Down><Down>
nnoremap <silent><leader>gd :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <silent><leader>gf :G fetch<cr>
nnoremap <silent><leader>gp :G pull<cr>
nnoremap <silent><leader>gt :G push --tags<CR>
nnoremap <silent><leader>gu :G push<cr>

" Display all diffs in a collection of tabs.
nnoremap <leader>gy :G difftool -y<space>

" Accept left or right changes in the diff.
nnoremap <silent><leader>gm <cmd>diffget //2<CR>
nnoremap <silent><leader>gi <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <silent><leader>g<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <silent><leader>g<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
