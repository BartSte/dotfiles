if has('termguicolors')
    set termguicolors

    let g:gruvbox_transparant_mode=0
    let g:gruvbox_baby_string_style='nocombine'
    let g:gruvbox_baby_comment_style='italic'
    let g:gruvbox_baby_keyword_style='italic'
    let g:gruvbox_baby_function_style='bold'
    let g:gruvbox_baby_variable_style='NONE'
    let g:gruvbox_baby_background_color='dark'
    let g:gruvbox_baby_use_original_palette=0

    colorscheme gruvbox-baby

    hi! link Folded Normal
    hi LineNr guifg=LightGray
    hi Search guifg=fg guibg=DarkGreen
    hi IncSearch gui=bold guifg=fg guibg=DarkMagenta
    hi CursorLineNr gui=bold guifg=LightGreen
    hi HighlightedyankRegion gui=bold guifg=fg guibg=DarkMagenta

    hi Tabline gui=bold guibg=bg
    hi TablineSel gui=bold guibg=bg 

    hi HopNextKey guibg=bg
    hi HopNextKey1 guibg=bg
    hi HopNextKey2 guibg=bg

    hi FloatermBorder guibg=bg

    hi SpellBad gui=undercurl guisp=Red guifg=Normal

    hi ColorColumn guibg=#32302f
    hi TreesitterContext gui=bold guibg=#31302f
    hi TreesitterContextBottom gui=bold guibg=#31302f
    hi TreesitterContextLineNumber gui=bold guifg=LightGreen guibg=#31302f

endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

