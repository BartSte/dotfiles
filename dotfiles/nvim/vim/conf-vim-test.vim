function! MyUnitTestStrategy(cmd)
    let testName = split(a:cmd)[-1]
    call vimspector#LaunchWithSettings( #{ configuration: 'unittest', TestName: testName } )
endfunction

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}
let g:test#neovim#start_normal = 1 

noremap gl :TestVisit<CR>
noremap <a-t> :only<bar>TestNearest -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-l> :only<bar>TestLast -strategy=dispatch -v<bar>wincmd L<CR><CR>
noremap <a-f> :only<bar>TestFile -strategy=dispatch -v<bar>wincmd L<CR><CR>
noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-L> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>
