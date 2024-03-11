if has('termguicolors')
    hi IncSearch cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
    hi MatchParen gui=bold guifg=#fe8019 guibg=#1d2021
    hi CursorLineNr gui=bold guifg=LightGreen
    hi Tabline gui=bold guibg=bg
    hi TablineSel gui=bold guibg=bg 
    hi FloatermBorder guibg=bg
    hi SpellBad gui=undercurl guisp=Red guifg=Normal
    hi ColorColumn guibg=#32302f
    hi TreesitterContext gui=bold guibg=#31302f
    hi TreesitterContextBottom gui=bold guibg=#31302f
    hi TreesitterContextLineNumber gui=bold guifg=LightGreen guibg=#31302f
    hi HopNextKey guibg=Normal
    hi HopNextKey1 guibg=Normal
    hi HopNextKey2 guibg=Normal
endif
