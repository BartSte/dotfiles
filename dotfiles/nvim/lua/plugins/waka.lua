local os_path = require('helpers.os_path')
return {
    'wakatime/vim-wakatime',
    cond = function()
        --through the shell, check if .wakatime.cfg exists.
        local file = io.open(os_path.get_home() .. "/.wakatime.cfg", "r")
        local exists = file ~= nil
        if exists then
            io.close(file)
        end
        return exists
    end
}
