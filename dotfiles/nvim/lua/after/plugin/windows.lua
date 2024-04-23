if vim.fn.has('win32') == 1 then
    vim.o.shell = 'pwsh'
    vim.o.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end


if os.getenv('WH') then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] =
            'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] =
            'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end
