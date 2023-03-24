if has('win32')
    " let g:python3_host_prog = stdpath('data') . '\mason\packages\debugpy\venv\Scripts\python.exe'
    let g:python3_host_prog = $LOCALAPPDATA . '\Programs\Python\Python311\python.exe'
    let &shell = has('win32') ? 'powershell' : 'pwsh'
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
