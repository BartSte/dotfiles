if has("win32")
    let $SHELL = 'cmd.exe'
endif

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'
let $FZF_DEFAULT_COMMAND = "ag --hidden --skip-vcs-ignores --path-to-ignore " . $HOME . "\\.ignore -g ."

let NERDTreeShowHidden=1
let NERDTreeMapMenu='a'

let ayucolor="darker" 

let mapleader = " "

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_bold=0
let g:gruvbox_invert_signs=0
let g:gruvbox_guisp_fallback='fg'

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;,./<>?!@#$%{[(`}])"~=_789*+\456-|123ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_smartcase = 1

let g:auto_save = 1
let g:auto_save_events = ["WinLeave", "InsertLeave"]
let g:auto_save_silent = 1

let g:coc_config_home = '~/.vim' 
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright',
                             \ 'coc-pydocstring', 'coc-sh', 'coc-html', 
                             \ 'coc-powershell']

let g:highlightedyank_highlight_duration = 200

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:rainbow_active = 1

let g:test#custom_strategies = {'pyunit': function('PyUnitTestStrategy')}

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype', 'fileencoding' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

