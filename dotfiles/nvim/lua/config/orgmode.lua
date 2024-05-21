local mapper = require('helpers.keymapper')
local orgmode = require('orgmode')
local path = require('helpers.path')
local khalorg = require('khalorg')

local dropbox_home = path.join(path.home(), 'dropbox')
local dropbox_org = path.join(dropbox_home, 'org')
local main = path.join(dropbox_org, 'main.org')
local agenda = path.join(dropbox_org, 'outlook.org')
local personal = path.join(dropbox_org, 'personal.org')
local gedachten = path.join(dropbox_org, 'gedachten.org')
local outlook = path.join(dropbox_org, 'outlook.org')

khalorg.setup({
    calendar = 'outlook_local'
})

local template_gedachte = [[
* %?%U
** Situatie

** Gevoel

*** Hoe sterk is het gevoel?

** Automatische gedachte 

*** Hoe geloofwaardig zijn deze gedachte?

** Uitdagen

*** Stel vragen over de automatische gedachten

*** Wat zijn de antwoorden op deze vragen?

** Alternatieve gedachte

*** Zet altenatieve gedachten tegenover de automatische gedachten

*** Hoe geloofwaardig zijn de alternatieve gedachten?

** Resultaat

*** Hoe geloofwaardig zijn de automatische gedachten nu?

*** Hoe sterk is het gevoel nu?

]]

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

local templates = {
    t = {
        description = 'Todo',
        template = '* TODO %?\n  %U\n  %a',
        target = main
    },
    g = {
        description = 'Gedachte',
        template = template_gedachte,
        target = gedachten
    },
    e = {
        description = 'Event',
        template = '*\n\n:PROPERTIES:\n:ATTENDEES: \n:LOCATION: \n:ORGANIZER: \n:RRULE: \n:STATUS: \n:UID: \n:URL: \n:UNTIL: \n:END:\n',
        target = outlook
    }
}

orgmode.setup({
    mappings = mappings,
    org_default_notes_file = main,
    org_agenda_files = { main, agenda, personal, gedachten },
    org_blank_before_new_entry = { heading = true, plain_list_item = false },
    org_hide_emphasis_markers = true,
    org_custom_exports = custom_exports,
    win_split_mode = 'vertical',
    org_todo_keywords = { 'TODO', 'MEET', 'NEXT', 'WAIT', '|', 'DONE', 'CANCEL' },
    org_capture_templates = templates,
    org_todo_keyword_faces = {
        WAIT = ':foreground orange :weight bold',
        NEXT = ':foreground yellow :weight bold',
        CANCEL = ':foreground magenta :weight bold'
    },
})

mapper.nnoremap('<a-r>', ':Files ' .. dropbox_org .. '<CR>')
