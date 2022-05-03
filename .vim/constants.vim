let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all'
let $FZF_DEFAULT_COMMAND = 'ag --hidden -g .'

let NERDTreeShowHidden=1

let ayucolor="darker" 

let mapleader = " "

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;,./<>?!@#$%{[(`}])"~=_789*+\456-|123ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_smartcase = 1

let g:auto_save = 1
let g:auto_save_events = ["FocusLost", "WinLeave", "CursorHold"]
let g:auto_save_silent = 0

let g:coc_config_home = '~/.vim' 
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-pydocstring', 'coc-sh', 'coc-html', 'coc-powershell']

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'PreProc', 'Normal'],
  \ 'bg+':     ['bg', 'Normal'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:rainbow_active = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:test#custom_strategies = {'pyunit': function('PyUnitTestStrategy')}

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']

let g:lightline = {
      \ 'colorscheme': 'powerline',
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

" Set the curson for terminal (only linux)
if &term =~ "xterm\\|rxvt"
    let &t_SI = "\<Esc>]12;white\x7"
    let &t_EI = "\<Esc>]12;white\x7"
    silent !echo -ne "\033]12;white\007"
    autocmd VimLeave * silent !echo -ne "\033]112\007"
    let &t_SI .= "\<Esc>[5 q"
    let &t_EI .= "\<Esc>[0 q"
endif
