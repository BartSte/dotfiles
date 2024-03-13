" Make a global function that task a name as an argument
function! s:setkanagawa(name)
    if has("termguicolors")

        set termguicolors
        hi clear
        set background=dark
        execute 'colorscheme ' . a:name

        hi Folded guifg=gray65 guibg=bg
        hi LineNr guifg=LightGray guibg=bg
        hi WinSeparator guifg=gray22 guibg=bg

    endif
endfunction

command! Wave call s:setkanagawa('kanagawa-wave')
command! Dragon call s:setkanagawa('kanagawa-dragon')
