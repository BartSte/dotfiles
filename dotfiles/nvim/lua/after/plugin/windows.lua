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
    -- tmux popups can inherit a PATH without Windows executables.
    local clip = vim.fn.exepath('clip.exe')
    if clip == '' then
        clip = '/mnt/c/Windows/System32/clip.exe'
    end
    local powershell = vim.fn.exepath('pwsh.exe')
    if powershell == '' then
        powershell = '/mnt/c/Program Files/PowerShell/7/pwsh.exe'
        if vim.fn.executable(powershell) == 0 then
            powershell = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe'
        end
    end
    local paste = {
        powershell, '-NoLogo', '-NoProfile', '-ExecutionPolicy', 'RemoteSigned', '-Command',
        '[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; [Console]::Out.Write(([string](Get-Clipboard -Raw)).Replace("`r", ""))',
    }
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = { clip },
            ['*'] = { clip },
        },
        paste = {
            ['+'] = paste,
            ['*'] = paste,
        },
        cache_enabled = 0,
    }
end
