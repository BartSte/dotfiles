if has('termguicolors')
    set termguicolors

    let g:gruvbox_baby_background_color='medium'
    let g:gruvbox_baby_comment_style='italic'
    let g:gruvbox_baby_function_style='bold'
    let g:gruvbox_baby_keyword_style='italic'
    let g:gruvbox_baby_string_style='nocombine'
    let g:gruvbox_baby_variable_style='NONE'

    colorscheme gruvbox-baby
    hi! link ColorColumn CursorLine
    hi HighlightedyankRegion guibg=DarkGreen
    hi Folded guifg=#999999
    hi LineNr guifg=#999999
    hi CursorLineNr guifg=#FFFFFF

endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

