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

    runtime vim/config/gruvbox-baby.vim
endif

