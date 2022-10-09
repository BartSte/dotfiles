command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

inoremap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent><C-p> <C-r>=CocActionAsync('showSignatureHelp')<CR>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <silent><expr> <c-space> coc#refresh()

nmap <leader>r <Plug>(coc-rename)
nmap <leader>cd <Plug>(coc-action-toggleDiagnosticsBuffer)
nmap <silent> <a-c> :CocDiagnostics<CR>
nmap <silent><a-k> :call ShowDocumentation()<CR>
nmap <silent><leader>ca <Plug>(coc-codeaction-line)
nmap <silent><leader>cq <Plug>(coc-fix-current)
noremap <silent><leader><BS> :Format<CR>
noremap <silent><leader>i :OR<CR>

xmap <silent><leader>ca <Plug>(coc-codeaction-selected)
xmap <silent><leader><BS> <Plug>(coc-format-selected)
xnoremap <C-l> <Plug>(coc-convert-snippet)

