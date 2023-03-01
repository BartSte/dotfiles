let test#python#runner = 'pyunit'
" let g:test#neovim#start_normal = 1 

noremap gl :TestVisit<CR>
noremap <a-t> :only<bar>TestNearest -strategy=harpoon<bar>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>
noremap <a-l> :only<bar>TestLast -strategy=harpoon<bar>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>
noremap <a-f> :only<bar>TestFile -strategy=harpoon<bar>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>
