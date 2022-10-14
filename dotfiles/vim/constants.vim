let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let mapleader = " "

let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave", "CursorHold"]

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-s']

let g:highlightedyank_highlight_duration = 150

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:rainbow_active = 1

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}

let g:vimspector_base_dir = expand('$HOME/dotfiles/vim/vimspector')
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ["debugpy","vscode-cpptools", "debugpy-python2"]

