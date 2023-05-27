let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-p']

function! s:GetEmail()
    call fzf#run(fzf#wrap({
                \ 'source': "khard --skip-unparsable email --parsable --remove-first-line | sed 's/[ \t].*$//'",
                \ 'sink': 'normal! i',
                \ 'window': {'width': 0.9, 'height': 0.6},
                \ 'header': 'Select an email address:',
                \ }))
endfunction

function! s:Dirs()
    call fzf#run(fzf#wrap({
                \ 'source': "eval $FZF_ALT_C_COMMAND",
                \ 'sink': 'NvimTreeClose | NvimTreeOpen',
                \ 'window': {'width': 0.9, 'height': 0.6},
                \ 'header': 'Select a directory',
                \ 'options': ['--preview', 'exa --icons -T -L 1 -a {} | head -200', '--bind', 'ctrl-p:toggle-preview', '--preview-window', 'hidden']
                \ }))
endfunction

command! Email call s:GetEmail()
command! Dirs call s:Dirs()
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(
            \ <q-args>, 
            \ fzf#vim#with_preview(), 
            \ <bang>0)

nnoremap <a-a> :Ag<space>
inoremap <a-a> <Esc>:Ag<space>

if has('win32')
    " Workaround for: https://github.com/junegunn/fzf.vim/issues/883
    noremap <a-o> <cmd>call ExecInCmd('Files')<CR>
    noremap <a-b> <cmd>call ExecInCmd('Buffers')<CR>
    noremap <a-v> <cmd>call ExecInCmd('Files ~/dotfiles/nvim')<CR>
    noremap <a-M> <cmd>call ExecInCmd('Marks')<CR>
    noremap <a-h> <cmd>call ExecInCmd('Helptags')<CR>
    noremap <a-c> <cmd>call ExecInCmd('Dirs')<CR>
else
    noremap <a-o> <cmd>Files<CR>
    noremap <a-b> <cmd>Buffers<CR>
    noremap <a-v> <cmd>Files ~/dotfiles/nvim<CR>
    noremap <a-M> <cmd>Marks<CR>
    noremap <a-h> <cmd>Helptags<CR>
    noremap <a-c> <cmd>Dirs<CR>
endif

