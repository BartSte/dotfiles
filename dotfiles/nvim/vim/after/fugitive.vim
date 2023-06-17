let g:flog_default_opts = {'max_count': 500 }

noremap <a-g> :G<space>
noremap <a-G> :vertical G<CR>'"
noremap <a-z> :GV<CR>
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
nnoremap <buffer><leader><leader>m <cmd>diffget //2<CR>
nnoremap <buffer><leader><leader>i <cmd>diffget //3<CR>
