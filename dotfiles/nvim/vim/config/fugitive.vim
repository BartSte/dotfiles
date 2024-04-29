noremap <a-g> :G<space>
noremap <a-G> :G<CR>:wincmd H<CR>}jj
noremap <a-d> :silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>
noremap <a-D> :silent! normal gf<CR>:wincmd o<bar>G mergetool<CR>
nnoremap <leader>m <cmd>diffget //2<CR>
nnoremap <leader>i <cmd>diffget //3<CR>

"Simplify the diff navigation by searching for <<, ===, and >>.
nnoremap <leader><leader><CR> /<[<]\+\\|==[=]\+\\|>[>]\+<CR>
nnoremap <leader><leader><BS> ?<[<]\+\\|==[=]\+\\|>[>]\+<CR>

"I can use :G difftool branch1..branch2 to open the modified files in the quickfix list. Now I need
"to make a mapping that behaves like :cnext, but now instead of opening the next file in the quickfix,
"we want to open the next file in a Gvdiffsplit. Before I do that, I need to make sure that all
"windows except the quickfix window are closed.
nnoremap <leader>dn :silent! :wincmd o<CR>:cnext<CR>:Gvdiffsplit<CR>:copen<CR>:.cc<CR>
nnoremap <leader>dp :silent! :wincmd o<CR>:cprev<CR>:Gvdiffsplit<CR>:copen<CR>:.cc<CR>
