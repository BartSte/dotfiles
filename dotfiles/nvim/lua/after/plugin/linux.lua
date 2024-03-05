if vim.fn.has('linux') == 1 then
    if os.getenv("VIRTUAL_ENV") then
        vim.g.python3_host_prog = os.getenv("VIRTUAL_ENV") .. '/bin/python'
    else
        vim.g.python3_host_prog = '/usr/bin/python3'
    end
end
