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

"     let bg='#282828'
"     hi ErrorFloat guibg=bg
"     hi FloatBorder guibg=Normal    
"     hi HintFloat guibg=bg
"     hi InfoFloat guibg=bg
"     hi LineNr guifg=grey
"     hi NormalFloat guibg=Normal
"     hi Pmenu guibg=Normal
"     hi PmenuSel guifg=#67afaf guibg=Normal
"     hi WarningFloat guibg=bg
"     hi Search guibg=#d8a657

endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

