if has('termguicolors')
    set termguicolors

    hi! link Folded Normal
    hi LineNr guifg=LightGray
    " hi Search gui=bold
    " hi IncSearch gui=bold guifg=fg " guibg=DarkMagenta
    " hi CursorLineNr gui=bold guifg=LightGreen
    " hi HighlightedyankRegion gui=bold guifg=fg guibg=DarkMagenta
    " hi WinSeparator guifg=gray28

    " hi Tabline gui=bold guibg=bg
    " hi TablineSel gui=bold guibg=bg 

    hi HopNextKey guifg=Yellow gui=bold
    hi HopNextKey1 guifg=Yellow gui=bold
    hi HopNextKey2 guifg=Red gui=bold

    " hi FloatermBorder guibg=bg

    " hi SpellBad gui=undercurl guisp=Red guifg=Normal

    " hi ColorColumn guibg=#32302f
    " hi TreesitterContext gui=bold guibg=#31302f
    " hi TreesitterContextBottom gui=bold guibg=#31302f
    " hi TreesitterContextLineNumber gui=bold guifg=LightGreen guibg=#31302f

    hi CopilotSuggestion gui=italic guifg=gray65

    " hi MatchParen gui=bold guifg=fg guibg=DarkMagenta
endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"
