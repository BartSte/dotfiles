return {
    'wakatime/vim-wakatime',
    cond = function()
        --through the shell, check if .wakatime.cfg exists.
        --TODO: what about windows?
        local file = io.open(os.getenv("HOME") .. "/.wakatime.cfg", "r")
        if file ~= nil then
            io.close(file)
            return true
        else
            return false
        end
    end
}
