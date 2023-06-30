let $FZF_DEFAULT_COMMAND = expand('fd --hidden --no-ignore-vcs --ignore-file $HOME/.ignore -t f')
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --height 100% --reverse --border'

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-p']

function! s:GetEmail()
    call fzf#run(fzf#wrap({
                \ 'source': "khard --skip-unparsable email --parsable --remove-first-line | sed 's/[ \t].*$//'",
                \ 'sink': 'normal! i',
                \ 'window': {'width': 0.9, 'height': 0.6},
                \ 'header': 'Select an email address:',
                \ }))
endfunction

command! Email call s:GetEmail()
command! -bang -nargs=? -complete=dir Dirs call fzf#vim#files(<q-args>, {
            \ 'source': "eval $FZF_ALT_C_COMMAND", 
            \ 'header': 'Select a directory', 
            \ 'options': $FZF_ALT_C_OPTS}, 
            \ <bang>0)

nnoremap <a-a> :Ag<space>
inoremap <a-a> <Esc>:Ag<space>

if has('win32')
    " Workaround for: https://github.com/junegunn/fzf.vim/issues/883
    noremap <a-o> <cmd>call ExecInCmd('Files')<CR>
    noremap <a-b> <cmd>call ExecInCmd('Buffers')<CR>
    noremap <a-v> <cmd>call ExecInCmd('Files ~/dotfiles/nvim')<CR>
    noremap <a-M> <cmd>call ExecInCmd('Marks')<CR>
    noremap <a-h> <cmd>call ExecInCmd('Files ~')<CR>
    noremap <a-H> <cmd>call ExecInCmd('Helptags')<CR>
    noremap <a-c> <cmd>call ExecInCmd('Dirs')<CR>
    noremap <a-B> <cmd>call ExecInCmd('GBranches')<CR>
else
    noremap <a-o> <cmd>Files<CR>
    noremap <a-b> <cmd>Buffers<CR>
    noremap <a-v> <cmd>Files ~/dotfiles/nvim<CR>
    noremap <a-M> <cmd>Marks<CR>
    noremap <a-h> <cmd>Files ~<CR>
    noremap <a-H> <cmd>Helptags<CR>
    noremap <a-c> <cmd>Dirs<CR>
    noremap <a-V> <cmd>Dirs ~/dotfiles/nvim<CR>
    noremap <a-B> <cmd>GBranches<CR>
endif

