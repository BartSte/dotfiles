nnoremap <leader>G :G<CR>:wincmd H<CR>}<Down><Down>

nnoremap <leader>gf :G fetch<cr>
nnoremap <leader>gp :G pull<cr>
nnoremap <leader>gP :!git-update<cr>
nnoremap <leader>gs :G switch<space>

nnoremap <leader>gu :G push<cr>
nnoremap <leader>gt :G push --tags<CR>
nnoremap <leader>gU :G push --force-with-lease
nnoremap <leader>gT :G push --tags --force-with-lease

nnoremap <leader>gac :G cherry-pick --abort<CR>
nnoremap <leader>gcc :G cherry-pick --continue<CR>

nnoremap <leader>ge :G merge<space>
nnoremap <leader>gae :G merge --abort<CR>
nnoremap <leader>gce :G merge --continue<CR>

nnoremap <leader>gr :G rebase<space>
nnoremap <leader>gar :G rebase --abort<CR>
nnoremap <leader>gcr :G rebase --continue<CR>

nnoremap <leader>gR :G reset<space>

nnoremap <leader>gd :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <leader>gD :Gvdiffsplit<space>

" Display all diffs in a collection of tabs.
nnoremap <leader>gy :G difftool -y<space>

" Accept left or right changes in the diff.
nnoremap <silent><leader>gm <cmd>diffget //2<CR>
nnoremap <silent><leader>gi <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <silent><leader>g<CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <silent><leader>g<BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>
