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
local dropbox_notes = os_path.path_join(dropbox_home, 'org')
local dropbox_agenda = os_path.path_join(dropbox_home, 'Agenda/*')
local dropbox_main = os_path.path_join(dropbox_home, 'org', 'main.org')

orgmode.setup_ts_grammar()

orgmode.setup({
    org_default_notes_file = dropbox_main,
    org_agenda_files = dropbox_agenda,
    org_todo_keywords = { 'TODO', 'WAITING', 'MEETING', '|', 'DONE', 'CANCEL' },
    emacs_config = { executable_path = 'emacs', config_path = '$HOME/.doom.d/init.el' },
    org_blank_before_new_entry = {heading = true, plain_list_item = false},
    org_hide_emphasis_markers = true
})

bullets.setup({})


mapper.nnoremap('<a-r>', ':Files ' .. dropbox_notes .. '<CR>')