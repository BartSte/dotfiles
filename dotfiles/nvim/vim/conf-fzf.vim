let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-s']

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ag 
            \ call fzf#vim#ag(<q-args>, "--hidden --skip-vcs-ignores --path-to-ignore " . $HOME . "\\.ignore", fzf#vim#with_preview(), <bang>0)

noremap <a-o> <cmd>Files<CR>
noremap <a-a> :Ag<space>
noremap <a-b> <cmd>Buffers<CR>
noremap <a-v> <cmd>Files ~/dotfiles/nvim<CR>
