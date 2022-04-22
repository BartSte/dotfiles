let NERDTreeShowHidden=1

let ayucolor="darker" 

let mapleader = " "

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;,./<>?!@#$%{[(`}])"~=_789*+\456-|123ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_smartcase = 1

let g:ackprg = 'ag --nogroup --nocolor --column'

let g:auto_save = 1
let g:auto_save_events = ["FocusLost"]
let g:auto_save_silent = 0

let g:python_highlight_all = 1

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

