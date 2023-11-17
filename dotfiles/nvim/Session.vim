let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/navigation
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 docs/rov/automation/controllers/controllers.md
badd +446 src/navigation/rov/automation/controllers/abstracts.py
badd +39 src/navigation/rov/automation/dataclasses.py
badd +1 src/navigation/rov/automation/executor.py
badd +275 src/navigation/tools/jobs_factory.py
badd +65 src/navigation/rov/automation/tasks.py
badd +1 src/navigation/settings/settings.py
badd +69 src/navigation/rov/automation/driver.py
badd +204 src/navigation/rov/automation/controllers/robot_controller.py
badd +1 src/navigation/rov/automation/controllers/turn_controller.py
badd +65 /mnt/c/Users/BartSteensma/Dropbox/org/main.org
badd +334 src/navigation/rov/automation/controllers/stopcondition.py
badd +431 test/test_rov/test_automation/test_controllers/test_stopcondition.py
badd +153 /mnt/c/Users/BartSteensma/AppData/Roaming/Fleet\ Cleaner/Navigation/settings_config.ini
badd +24 src/navigation/rov/automation/controllers/line_controller.py
badd +3 ~/dotfiles/nvim/lua/plugins/cmp.lua
badd +1 ~/dotfiles/nvim/lua/plugins/undotree.lua
badd +1 ~/dotfiles/nvim/lua/plugins/fugitive.lua
badd +1 ~/dotfiles/nvim/vim/fzf.vim
badd +1 ~/dotfiles/nvim/lua/plugins/fzf.lua
badd +1 ~/dotfiles/nvim/vim/undotree.vim
argglobal
%argdel
edit test/test_rov/test_automation/test_controllers/test_stopcondition.py
argglobal
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=20
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 2 - ((1 * winheight(0) + 34) / 69)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 2
normal! 0
lcd ~/dotfiles/nvim
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
