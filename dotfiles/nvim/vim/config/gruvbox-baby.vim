if has('termguicolors')
    hi LineNr guifg=LightGray
    hi IncSearch gui=bold guifg=fg guibg=DarkMagenta
    hi MatchParen gui=bold guifg=fg guibg=DarkMagenta
    hi CursorLineNr gui=bold guifg=LightGreen
    hi HighlightedyankRegion gui=bold guifg=fg guibg=DarkMagenta
    hi WinSeparator guifg=gray28
    hi Tabline gui=bold guibg=bg
    hi TablineSel gui=bold guibg=bg 
    hi FloatermBorder guibg=bg
    hi SpellBad gui=undercurl guisp=Red guifg=Normal
    hi ColorColumn guibg=#32302f
    hi TreesitterContext gui=bold guibg=#31302f
    hi TreesitterContextBottom gui=bold guibg=#31302f
    hi TreesitterContextLineNumber gui=bold guifg=LightGreen guibg=#31302f
endif
