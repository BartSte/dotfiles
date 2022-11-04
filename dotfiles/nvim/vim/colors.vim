if has('termguicolors')
    set termguicolors
    set background=dark

    let g:gruvbox_material_background='medium'
    let g:gruvbox_material_foreground='material'
    let g:gruvbox_material_enable_bold=0
    let g:gruvbox_material_ui_contrast='medium'
    let g:gruvbox_material_enable_italic=1
    let g:gruvbox_material_statusline_style='original'
    let g:gruvbox_material_transparent_background=0
    let g:gruvbox_material_diagnostic_text_highlight=1
    let g:gruvbox_material_diagnostic_line_highlight=0
    let g:gruvbox_material_better_performance = 1

    colorscheme gruvbox-material
    let bg='#282828'
    hi ErrorFloat guibg=bg
    hi FloatBorder guibg=Normal    
    hi HighlightedyankRegion guibg=DarkGreen
    hi HintFloat guibg=bg
    hi InfoFloat guibg=bg
    hi LineNr guifg=grey
    hi NormalFloat guibg=Normal
    hi Pmenu guibg=Normal
    hi PmenuSel guifg=#67afaf guibg=Normal
    hi WarningFloat guibg=bg
    hi Search guibg=DarkMagenta guifg=White
    hi IncSearch guibg=DarkGreen guifg=White
endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"
