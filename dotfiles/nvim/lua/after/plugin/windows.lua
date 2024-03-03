local M = {}

-- Vimscript
-- function! g:ExecInCmd(command)
--     " Workaround for: https://github.com/junegunn/fzf.vim/issues/883
--     let tmp=&shell
--     let tmp_shellpipe = &shellpipe
--     let tmp_shellquote = &shellquote
--     let tmp_shellredir = &shellredir
--     let tmp_shellxquote = &shellxquote
--     let tmp_shellcmdflag = &shellcmdflag
--
--     set shellquote = 
--     let &shellpipe = '>%s 2>&1'
--     set shellxquote = "\""
--     let &shellredir = '>%s 2>&1'
--     let &shellcmdflag = '/s /c'
--
--     set shell=cmd
--     execute a:command
--
--     let &shell=tmp
--     let &shellpipe = tmp_shellpipe
--     let &shellredir = tmp_shellredir
--     let &shellquote = tmp_shellquote
--     let &shellxquote = tmp_shellxquote
--     let &shellcmdflag = tmp_shellcmdflag
-- endfunction

local function exec_in_cmd(command)
    local tmp = vim.o.shell
    local tmp_shellpipe = vim.o.shellpipe
    local tmp_shellquote = vim.o.shellquote
    local tmp_shellredir = vim.o.shellredir
    local tmp_shellxquote = vim.o.shellxquote
    local tmp_shellcmdflag = vim.o.shellcmdflag

    vim.o.shellquote = ""
    vim.o.shellpipe = '>%s 2>&1'
    vim.o.shellxquote = "\""
    vim.o.shellredir = '>%s 2>&1'
    vim.o.shellcmdflag = '/s /c'

    vim.o.shell = 'cmd'
    vim.cmd(command)

    vim.o.shell = tmp
    vim.o.shellpipe = tmp_shellpipe
    vim.o.shellredir = tmp_shellredir
    vim.o.shellquote = tmp_shellquote
    vim.o.shellxquote = tmp_shellxquote
    vim.o.shellcmdflag = tmp_shellcmdflag
end

M.setup = function()
    vim.g.exec_in_cmd = exec_in_cmd

    -- Vimscript
    -- if has('win32')
    --     let g:python3_host_prog = $LOCALAPPDATA . '\Programs\Python\Python311\python.exe'
    --     let &shell = 'pwsh'
    --     let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    --     let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    --     let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    --     set shellquote= shellxquote=
    -- endif
    if vim.fn.has('win32') == 1 then
        vim.o.shell = 'pwsh'
        vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        vim.o.shellquote = ''
        vim.o.shellxquote = ''
    end


    -- Vimscript
    -- if !empty($WH)
    --     " See :h clipboard-wsl
    --     let g:clipboard = {
    --                 \   'name': 'WslClipboard',
    --                 \   'copy': {
    --                 \      '+': 'clip.exe',
    --                 \      '*': 'clip.exe',
    --                 \    },
    --                 \   'paste': {
    --                 \      '+': 'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --                 \      '*': 'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --                 \   },
    --                 \   'cache_enabled': 0,
    --                 \ }
    -- endif
    if os.getenv('WH') then
        vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
                ['+'] = 'clip.exe',
                ['*'] = 'clip.exe',
            },
            paste = {
                ['+'] = 'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ['*'] = 'pwsh.exe -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    end
end

return M
