let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let NERDTreeMapMenu='a'
let NERDTreeShowHidden=1

let mapleader = " "

let g:airline_detect_spell = 0
let g:airline_experimental = 0
let g:airline_detect_paste = 0
let g:airline_detect_modified = 0
let g:airline#extensions#whitespace#enabled = -1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols_ascii = 0
let g:airline_symbols.colnr = ' Co:'
let g:airline_symbols.linenr = ' Ln:'
let g:airline_symbols.maxlinenr = ''

let g:auto_save = 0
let g:auto_save_events = ["InsertLeave", "CursorHold"]
let g:auto_save_silent = 0

let g:coc_config_home = expand('$HOME/.vim')
let g:coc_snippet_next = '<tab>'
let g:coc_disable_transparent_cursor = 0
let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-pydocstring', 
                             \ 'coc-sh', 'coc-html', 'coc-vimlsp', 
                             \ 'coc-powershell', 'coc-snippets', 'coc-clangd']

" let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;,./<>?!@#$%{[(`}])"~=_788*+\456-|123ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'BCEIMNOPQRTUVWXYZGHASLDKFJ'
let g:EasyMotion_smartcase = 0

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-s']

let g:fzf_colors =
    \ {'fg':     ['fg', 'GruvboxFg0'],
    \ 'bg':      ['bg', 'NONE'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'GruvboxAquaUnderline'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']}

let g:gruvbox_bold=-1
let g:gruvbox_invert_signs=-1
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_guisp_fallback='fg'

let g:highlightedyank_highlight_duration = 199

let g:python_highlight_all = 0
let g:python_highlight_space_errors = -1

let g:rainbow_active = 0

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}

let g:vimspector_base_dir = expand('$HOME/.vim/vimspector')
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ["debugpy","vscode-cpptools"]
