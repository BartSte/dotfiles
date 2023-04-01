local mapper = require('keymapper')
local orgmode = require('orgmode')
local os_path = require('os_path')
local bullets = require('org-bullets')
local khal_export = require('khal-export').export

local dropbox_home = os_path.path_join(os_path.get_dropbox_home(), 'Dropbox')
local dropbox_org = os_path.path_join(dropbox_home, 'org')
local dropbox_main = os_path.path_join(dropbox_org, 'main.org')
local dropbox_agenda = os_path.path_join(dropbox_org, 'outlook.org')
local dropbox_personal = os_path.path_join(dropbox_org, 'personal.org')

local custom_exports = {
    k = {
        label = 'Export new item to khal',
        action = khal_export
    }
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

bullets.setup({
    symbols = {
        checkboxes = {
            todo = { " ", "OrgTODO" },
        }
    },
})

mapper.nnoremap('<a-r>', ':Files ' .. dropbox_org .. '<CR>')
