function! s:setgruvbox()
    if has("termguicolors")
        set termguicolors
        hi clear
        set background=dark
        colorscheme gruvbox-baby

        hi SpellBad gui=undercurl guisp=Red guifg=Normal
        hi ColorColumn guibg=#32302f
        hi CursorLineNr gui=NONE guifg=#fe8019 guibg=#32302f
        hi FloatBorder guibg=NONE guifg=gray65
        hi Folded guifg=gray65 guibg=bg
        hi HighlightedyankRegion cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
        hi HopNextKey guibg=Normal
        hi HopNextKey1 guibg=Normal
        hi HopNextKey2 guibg=Normal
        hi IncSearch cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
        hi LineNr guifg=LightGray guibg=bg
        hi MatchParen gui=bold guifg=#fe8019 guibg=#1d2021
        hi SpellBad gui=undercurl guisp=Red guifg=Normal
        hi TabLine guibg=bg 
        hi TabLineSel guibg=bg 
        hi TabLineFill guibg=bg 
        hi TreesitterContext guibg=#31302f
        hi TreesitterContextBottom gui=bold guibg=#31302f
        hi TreesitterContextLineNumber guifg=#fe8019 guibg=#32302f
        hi WinSeparator guifg=gray23 guibg=bg
    endif
endfunction

call s:setgruvbox()

command! Gruvbox call s:setgruvbox()
