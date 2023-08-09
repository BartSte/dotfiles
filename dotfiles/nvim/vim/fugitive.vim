noremap <a-g> :G<space>
noremap <a-G> :G<CR>:wincmd H<CR>/stage<CR>j^
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <leader>m <cmd>diffget //2<CR>
nnoremap <leader>i <cmd>diffget //3<CR>
