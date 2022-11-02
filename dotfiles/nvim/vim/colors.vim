if has('termguicolors')
    set termguicolors
    set background=dark

    let g:gruvbox_material_visual='green background'
    let g:gruvbox_material_background='medium'
    let g:gruvbox_material_foreground='material'
    let g:gruvbox_material_enable_bold=1
    let g:gruvbox_material_ui_contrast='low'
    let g:gruvbox_material_enable_italic=1
    let g:gruvbox_material_statusline_style='original'
    let g:gruvbox_material_transparent_background=0
    let g:gruvbox_material_diagnostic_text_highlight=1
    let g:gruvbox_material_diagnostic_line_highlight=0
    let g:gruvbox_material_menu_selection_background='grey'

    colorscheme gruvbox-material
    highlight PmenuSel guifg=#67afaf guibg=NONE
    highlight LineNr guifg=grey
endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"