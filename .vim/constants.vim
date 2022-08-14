let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'
  
let NERDTreeShowHidden=1
let NERDTreeMapMenu='a'

let mapleader = " "

let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_experimental = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_spell=1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' Co:'
let g:airline_symbols.linenr = ' Ln:'
let g:airline_symbols.maxlinenr = ''

let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "CursorHold"]
let g:auto_save_silent = 1

let g:coc_config_home = '~/.vim' 
let g:coc_snippet_next = '<tab>'
let g:coc_disable_transparent_cursor = 1
let g:coc_terminal_height = 2
let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-pydocstring', 
                             \ 'coc-sh', 'coc-html', 'coc-vimlsp', 
                             \ 'coc-powershell', 'coc-snippets']

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;,./<>?!@#$%{[(`}])"~=_789*+\456-|123ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_smartcase = 1

let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-p']
let g:fzf_colors =
\ { 'fg':      ['fg', 'GruvboxFg1'],
  \ 'bg':      ['bg', 'GruvboxBg3'],
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
  \ 'header':  ['fg', 'Comment'] }

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_bold=0
let g:gruvbox_invert_signs=0
let g:gruvbox_guisp_fallback='fg'

let g:highlightedyank_highlight_duration = 200

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:rainbow_active = 1

let test#python#runner = 'unittest'
let g:test#custom_strategies = {'pyunit': function('UnitTestStrategy')}

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy','vscode-cpptools']
let g:vimspector_base_dir = expand('$HOME/.vim/vimspector')
