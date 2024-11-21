nnoremap <leader>G :G<CR>:wincmd H<CR>
nnoremap <leader>gd :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <leader>gD :gvdiffsplit<space>
nnoremap <leader>ge :g merge<space>
nnoremap <leader>gf :g fetch<cr>
nnoremap <leader>gp :g pull<cr>
nnoremap <leader>gr :g rebase<space>
nnoremap <leader>gs :g switch<space>
nnoremap <leader>gt :g switch -t origin/
nnoremap <leader>gu :g push -f
nnoremap <leader>gu :g push<cr>

" Display all diffs in a collection of tabs.
nnoremap <leader>gy :g difftool -y<space>

" Accept left or right changes in the diff.
nnoremap <leader>gm <cmd>diffget //2<CR>
nnoremap <leader>gi <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <leader>g<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader>g<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
