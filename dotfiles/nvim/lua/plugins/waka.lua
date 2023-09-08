local path = require('helpers.path')
return {
    'wakatime/vim-wakatime',
    event = { 'InsertEnter' },
    cond = function()
        --through the shell, check if .wakatime.cfg exists.
        local file = io.open(path.get_home() .. "/.wakatime.cfg", "r")
        local exists = file ~= nil
        if exists then
            io.close(file)
        end
        return exists
    end
}
