return {
    'wakatime/vim-wakatime',
    cond = function()
        --through the shell, check if .wakatime.cfg exists.

        local home
        if vim.fn.has('win32') == 1 then
            home = os.getenv("USERPROFILE")
        else
            home = os.getenv("HOME")
        end

        local file = io.open(home .. "/.wakatime.cfg", "r")

        if file ~= nil then
            io.close(file)
            return true
        else
            return false
        end
    end
}
