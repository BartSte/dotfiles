function! s:setgruvbox()
    if has("termguicolors")

        set termguicolors
        hi clear
        set background=dark
        colorscheme gruvbox-baby

        hi ColorColumn guibg=#32302f
        hi CopilotSuggestion guifg=gray65 gui=italic 
        hi CursorLineNr gui=NONE guifg=#fe8019 guibg=#32302f
        hi FloatermBorder guibg=bg
        hi Folded guifg=gray65 guibg=bg
        hi HighlightedyankRegion cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
        hi HopNextKey guibg=Normal
        hi HopNextKey1 guibg=Normal
        hi HopNextKey2 guibg=Normal
        hi IncSearch cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
        hi LineNr guifg=LightGray guibg=bg
        hi MatchParen gui=bold guifg=#fe8019 guibg=#1d2021
        hi SpellBad gui=undercurl guisp=Red guifg=Normal
        hi Tabline gui=bold guibg=bg
        hi TablineSel gui=bold guibg=bg 
        hi TreesitterContext guibg=#31302f
        hi TreesitterContextBottom gui=bold guibg=#31302f
        hi TreesitterContextLineNumber guifg=#fe8019 guibg=#32302f
        hi WinSeparator guifg=gray22 guibg=bg
        hi WinSeparator guifg=gray28

    endif
endfunction

call s:setgruvbox()

command! Gruvbox call s:setgruvbox()
