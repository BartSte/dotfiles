if has('termguicolors')
    set termguicolors

    let g:gruvbox_baby_background_color='dark'
    let g:gruvbox_baby_comment_style='italic'
    let g:gruvbox_baby_function_style='bold'
    let g:gruvbox_baby_keyword_style='italic'
    let g:gruvbox_baby_string_style='nocombine'
    let g:gruvbox_baby_variable_style='NONE'

    colorscheme gruvbox-baby

    hi CursorLineNr guifg=#FFFFFF
    hi Folded guifg=#999999
    hi HighlightedyankRegion guibg=DarkGreen
    hi IncSearch guibg=DarkGreen
    hi LineNr guifg=#999999
    hi! link ColorColumn CursorLine

    hi Tabline guibg=NONE 
    hi! link TablineFill Normal
    hi! link TablineSel Normal

    hi HopNextKey guibg=NONE
    hi HopNextKey1 guibg=NONE
    hi HopNextKey2 guibg=NONE

endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

