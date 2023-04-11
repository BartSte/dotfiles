let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-p']

command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(
        \ <q-args>, 
        \ fzf#vim#with_preview(), 
        \ <bang>0)

if has('win32')
    " Workaround for: https://github.com/junegunn/fzf.vim/issues/883
    noremap <a-o> <cmd>call ExecInCmd('Files')<CR>
    noremap <a-a> :Ag<space>
    noremap <a-b> <cmd>call ExecInCmd('Buffers')<CR>
    noremap <a-v> <cmd>call ExecInCmd('Files ~/dotfiles/nvim')<CR>
    noremap <a-M> <cmd>call ExecInCmd('Marks')<CR>
    noremap <a-h> <cmd>call ExecInCmd('Helptags')<CR>
else
    noremap <a-o> <cmd>Files<CR>
    noremap <a-a> :Ag<space>
    noremap <a-b> <cmd>Buffers<CR>
    noremap <a-v> <cmd>Files ~/dotfiles/nvim<CR>
    noremap <a-M> <cmd>Marks<CR>
    noremap <a-h> <cmd>Helptags<CR>
endif
