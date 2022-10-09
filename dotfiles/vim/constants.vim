let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let NERDTreeMapMenu='a'
let NERDTreeShowHidden=1

let mapleader = " "

let g:airline_experimental = 1
let g:airline#extensions#whitespace#enabled = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols_ascii = 1
let g:airline_symbols.colnr = ' Co:'
let g:airline_symbols.linenr = ' Ln:'
let g:airline_symbols.maxlinenr = ''

let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave", "CursorHold"]

let g:coc_config_home = expand('$HOME/dotfiles/vim')
let g:coc_snippet_next = '<tab>'
let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-pydocstring', 
                             \ 'coc-sh', 'coc-html', 'coc-vimlsp', 
                             \ 'coc-powershell', 'coc-snippets', 'coc-clangd',
                             \ 'coc-lua']

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

let g:gruvbox_bold=0
let g:gruvbox_invert_signs=0
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_guisp_fallback='fg'

let g:highlightedyank_highlight_duration = 50

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:rainbow_active = 1

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}

let g:vimspector_base_dir = expand('$HOME/dotfiles/vim/vimspector')
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ["debugpy","vscode-cpptools", "debugpy-python2"]

