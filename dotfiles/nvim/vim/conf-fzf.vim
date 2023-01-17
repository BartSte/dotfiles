
let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-s']

command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(
        \ <q-args>, 
        \ fzf#vim#with_preview(), 
        \ <bang>0)

if has('win32')
    " On windows, the preview will not work when bash.exe of wsl is used. Use
    " git bash instead by placing it above wsl bash in the system environment
    " variables.
    
    " let g:fzf_preview_bash = 'C:\WINDOWS\system32\bash.exe'
    " command! -bang -nargs=* Ag
    "   \ call fzf#vim#grep(
    "   \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
    "   \   fzf#vim#with_preview(), <bang>0)

    command! -bang -nargs=* Ag 
        \ call fzf#vim#ag(
        \ <q-args>, 
        \ expand("--hidden --skip-vcs-ignores --path-to-ignore $HOME\.ignore"), 
        \ fzf#vim#with_preview(), 
        \ <bang>0)
else
    command! -bang -nargs=* Ag 
        \ call fzf#vim#ag(
        \ <q-args>, 
        \ expand("--hidden --skip-vcs-ignores --path-to-ignore $HOME/.ignore"), 
        \ fzf#vim#with_preview(), 
        \ <bang>0)
endif

noremap <a-o> <cmd>Files<CR>
noremap <a-a> :Ag<space>
noremap <a-b> <cmd>Buffers<CR>
noremap <a-v> <cmd>Files ~/dotfiles/nvim<CR>
noremap <a-M> <cmd>Marks<CR>
