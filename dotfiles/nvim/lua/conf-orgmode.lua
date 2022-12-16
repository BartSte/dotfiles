local orgmode = require('orgmode')
local bullets = require('org-bullets')
local os_path = require('os_path')
local mapper = require('keymapper')

--- For org + wsl, windows $USERPROFILE is used as home and is captured by the
--environment variable $WH (Windows Home).
local function get_home()
    local wsl_home = os.getenv('WH')
    if (wsl_home) then
        return wsl_home
    else
        return os.getenv('HOME')
    end
end

local dropbox_home = os_path.path_join(get_home(), 'Dropbox')
local dropbox_notes = os_path.path_join(dropbox_home, 'Notes', '*')
local dropbox_recepten = os_path.path_join(dropbox_home, 'Recepten', '*')
local dropbox_main = os_path.path_join(dropbox_home, 'Notes', 'Main.org')

orgmode.setup_ts_grammar()

orgmode.setup({
    org_default_notes_file = dropbox_main,
})

bullets.setup({})


mapper.nnoremap('<a-r>', ':Files ' .. dropbox_home .. '<CR>')
