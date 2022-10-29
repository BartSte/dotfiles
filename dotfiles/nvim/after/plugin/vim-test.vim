function! MyUnitTestStrategy(cmd)
    let testName = split(a:cmd)[-1]
    call vimspector#LaunchWithSettings( #{ configuration: 'unittest', TestName: testName } )
endfunction

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}

noremap gl :TestVisit<CR>
noremap <a-t> :only<bar>TestNearest -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-s> :only<bar>TestLast -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-f> :only<bar>TestFile -strategy=neovim -v<bar>wincmd L<CR><CR>
noremap <a-T> :TestNearest -strategy=unittest<CR>
noremap <a-S> :TestLast -strategy=unittest<CR>
noremap <a-F> :TestFile -strategy=unittest<CR>
