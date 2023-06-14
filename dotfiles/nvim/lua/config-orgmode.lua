local mapper = require('keymapper')
local orgmode = require('orgmode')
local os_path = require('os_path')
local khalorg = require('khalorg')

local dropbox_home = os_path.path_join(os_path.get_dropbox_home(), 'Dropbox')
local dropbox_org = os_path.path_join(dropbox_home, 'org')
local dropbox_main = os_path.path_join(dropbox_org, 'main.org')
local dropbox_agenda = os_path.path_join(dropbox_org, 'outlook.org')
local dropbox_personal = os_path.path_join(dropbox_org, 'personal.org')

khalorg.setup({
    calendar = 'outlook_local'
})

local custom_exports = {
    n = { label = 'Add a new khal item', action = khalorg.new },
    d = { label = 'Delete a khal item', action = khalorg.delete },
    e = { label = 'Edit properties of a khal item', action = khalorg.edit },
    E = { label = 'Edit properties & dates of a khal item', action = khalorg.edit_all }
}

local mappings = {
    org = {
        org_toggle_checkbox = { '<F24>', '<S-F12>' }
    }
}

orgmode.setup_ts_grammar()

orgmode.setup({
    mappings = mappings,
    org_default_notes_file = dropbox_main,
    org_agenda_files = { dropbox_main, dropbox_agenda, dropbox_personal },
    org_blank_before_new_entry = { heading = true, plain_list_item = false },
    org_hide_emphasis_markers = true,
    org_custom_exports = custom_exports,
    win_split_mode = 'vertical',
    org_todo_keywords = { 'TODO', 'MEET', 'NEXT', 'WAIT', '|', 'JIRA', 'DONE', 'CANCEL' },
    org_todo_keyword_faces = {
        WAIT = ':foreground orange :weight bold',
        NEXT = ':foreground yellow :weight bold',
        CANCEL = ':foreground magenta :weight bold'
    }
})

mapper.nnoremap('<a-r>', ':Files ' .. dropbox_org .. '<CR>')
