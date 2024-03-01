let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 dotfiles/nvim/lua/plugins/mason.lua
badd +14 dotfiles/nvim/lua/config/mason-null-ls.lua
badd +14 dotfiles/nvim/lua/config/mason-lspconfig.lua
badd +10 dotfiles/nvim/lua/plugins/null-ls.lua
badd +3 dotfiles/nvim/lua/plugins/lspconfig.lua
badd +1 code/multiprocessing/test_queues.py
argglobal
%argdel
edit dotfiles/nvim/lua/plugins/mason.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 79 + 120) / 240)
exe 'vert 2resize ' . ((&columns * 79 + 120) / 240)
exe 'vert 3resize ' . ((&columns * 80 + 120) / 240)
argglobal
balt code/multiprocessing/test_queues.py
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=20
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 3 - ((2 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("dotfiles/nvim/lua/config/mason-null-ls.lua", ":p")) | buffer dotfiles/nvim/lua/config/mason-null-ls.lua | else | edit dotfiles/nvim/lua/config/mason-null-ls.lua | endif
if &buftype ==# 'terminal'
  silent file dotfiles/nvim/lua/config/mason-null-ls.lua
endif
balt dotfiles/nvim/lua/plugins/null-ls.lua
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=20
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 4 - ((3 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 0
lcd ~/dotfiles/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/dotfiles/nvim/lua/config/mason-lspconfig.lua", ":p")) | buffer ~/dotfiles/nvim/lua/config/mason-lspconfig.lua | else | edit ~/dotfiles/nvim/lua/config/mason-lspconfig.lua | endif
if &buftype ==# 'terminal'
  silent file ~/dotfiles/nvim/lua/config/mason-lspconfig.lua
endif
balt ~/dotfiles/nvim/lua/plugins/lspconfig.lua
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=20
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 4 - ((3 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 79 + 120) / 240)
exe 'vert 2resize ' . ((&columns * 79 + 120) / 240)
exe 'vert 3resize ' . ((&columns * 80 + 120) / 240)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
