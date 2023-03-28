function! g:ExecInCmd(command)
  let tmp=&shell
  let tmp_shellcmdflag = &shellcmdflag
  let tmp_shellredir = &shellredir
  let tmp_shellpipe = &shellpipe
  let tmp_shellquote = &shellquote
  let tmp_shellxquote = &shellxquote

  let &shellcmdflag = '/s /c'
  let &shellredir = '>%s 2>&1'
  let &shellpipe = '>%s 2>&1'
  set shellxquote = "\""
  set shellquote = 

  set shell=cmd
  execute a:command

  let &shell=tmp
  let &shellcmdflag=tmp_shellcmdflag
  let &shellredir = tmp_shellredir
  let &shellpipe = tmp_shellpipe
  let &shellquote = tmp_shellquote
  let &shellxquote = tmp_shellxquote
endfunction

if has('win32')
    let g:python3_host_prog = $LOCALAPPDATA . '\Programs\Python\Python311\python.exe'
    let &shell = 'pwsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

if !empty($WH)
    let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': '/mnt/c/Windows/System32/clip.exe',
    \      '*': '/mnt/c/Windows/System32/clip.exe',
    \    },
    \   'paste': {
    \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }
endif

