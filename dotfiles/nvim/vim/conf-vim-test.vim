function! MyUnitTestStrategy(cmd)
    let testName = split(a:cmd)[-1]
    call vimspector#LaunchWithSettings( #{ configuration: 'unittest', TestName: testName } )
endfunction

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}
let g:test#neovim#start_normal = 1 

noremap gl :TestVisit<CR>

" Long harpoon strategy ensures that 1 terminal is reused and that het windows
" are arranged properly.
noremap <a-t> :only<bar>TestNearest -strategy=harpoon<CR>gi<cmd>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>
noremap <a-l> :only<bar>TestLast -strategy=harpoon<CR>gi<cmd>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>
noremap <a-f> :only<bar>TestFile -strategy=harpoon<CR>gi<cmd>wincmd v<CR><cmd>wincmd l<bar>TestVisit<CR>

noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-L> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>
