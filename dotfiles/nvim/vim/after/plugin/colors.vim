if has('termguicolors')
    set termguicolors
    hi clear
    set background=dark
    colorscheme gruvbox-baby
    
    hi CopilotSuggestion guifg=gray65 gui=italic 
    hi Folded guifg=gray65 guibg=bg
    hi HighlightedyankRegion cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
    hi LineNr guifg=LightGray
    hi Search guibg=gray35 gui=bold 
    hi WinSeparator guifg=gray28

    " Gruvbox-baby adjustments
    hi ColorColumn guibg=#32302f
    hi CursorLineNr gui=NONE guifg=#fe8019 guibg=#32302f
    hi FloatermBorder guibg=bg
    hi HopNextKey guibg=Normal
    hi HopNextKey1 guibg=Normal
    hi HopNextKey2 guibg=Normal
    hi IncSearch cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
    hi MatchParen gui=bold guifg=#fe8019 guibg=#1d2021
    hi SpellBad gui=undercurl guisp=Red guifg=Normal
    hi Tabline gui=bold guibg=bg
    hi TablineSel gui=bold guibg=bg 
    hi TreesitterContext guibg=#31302f
    hi TreesitterContextBottom gui=bold guibg=#31302f
    hi TreesitterContextLineNumber guifg=#fe8019 guibg=#32302f
endif

