nnoremap <leader>G :G<CR>:wincmd H<CR>}<Down><Down>
nnoremap <leader>gd :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <leader>gD :gvdiffsplit<space>
nnoremap <leader>ge :G merge<space>
nnoremap <leader>gf :G fetch<cr>
nnoremap <leader>gp :G pull<cr>
nnoremap <leader>gr :G rebase<space>
nnoremap <leader>gs :G switch<space>
nnoremap <leader>gt :G switch -t origin/
nnoremap <leader>gU :G push -f
nnoremap <leader>gu :G push<cr>

" Display all diffs in a collection of tabs.
nnoremap <leader>gy :G difftool -y<space>

" Accept left or right changes in the diff.
nnoremap <leader>gm <cmd>diffget //2<CR>
nnoremap <leader>gi <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <leader>g<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>g<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
