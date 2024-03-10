if has('termguicolors')
    set termguicolors
    hi clear
    colorscheme gruvbox
    
    hi CopilotSuggestion guifg=gray65 gui=italic 
    hi Folded guifg=gray65 guibg=bg
    hi HighlightedyankRegion cterm=reverse gui=reverse guifg=#fe8019 guibg=#1d2021
    hi LineNr guifg=LightGray
    hi Search guibg=gray23 gui=bold 
    hi WinSeparator guifg=gray28
endif

