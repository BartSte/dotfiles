local orgmode = require('orgmode')
local path = require('helpers.path')
local khalorg = require('khalorg')

local dropbox_home = path.join(path.home(), 'dropbox')
local dropbox_org = path.join(dropbox_home, 'org')
local main = path.join(dropbox_org, 'main.org')
local personal = path.join(dropbox_org, 'personal.org')
local gedachten = path.join(dropbox_org, 'gedachten.org')
local komeco = path.join(dropbox_org, 'komeco.org')
local outlook_personal = path.join(dropbox_org, 'outlook_personal.org')
local outlook_work = path.join(dropbox_org, 'outlook_work.org')

khalorg.setup({
    calendar = 'outlook_local'
})

local template_gedachte = [[
* %?%U

** Situatie

** Gevoel

** Automatische gedachte

** Uitdagen

** Alternatieve gedachte

]]

local template_komeco = [[

* MEET Notulen %<%Y-%m-%d %H:%M>

:PROPERTIES:
:ATTENDEES:
:ORGANIZER:
:LOCATION:
:END:

** Opening

** Mededelingen

** Notulen

** Actie besluitenlijst

** Bespreking beurstoestand

** Presentaties

** Wijzigingen in de portefeuille

** Rondvraag

** WVTTK

** Sluiting

** Besluitenlijst

-

** Actiepunten

- [ ]
]]

local custom_exports = {
    n = { label = 'Add a new khal item', action = khalorg.new },
    d = { label = 'Delete a khal item', action = khalorg.delete },
    e = { label = 'Edit properties of a khal item', action = khalorg.edit },
    E = { label = 'Edit properties & dates of a khal item', action = khalorg.edit_all }
}

local mappings = {
    org = {
        org_toggle_checkbox = { '<C-Space>', '<S-F12>' }
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
    k = {
        description = 'Komeco',
        template = template_komeco,
        target = komeco
    },
    e = {
        description = 'Event',
        template =
        '*\n\n:PROPERTIES:\n:ATTENDEES: \n:LOCATION: \n:ORGANIZER: \n:RRULE: \n:STATUS: \n:UID: \n:URL: \n:UNTIL: \n:END:\n',
        target = outlook
    }
}

orgmode.setup({
    mappings = mappings,
    org_default_notes_file = main,
    org_agenda_files = { main, outlook_personal, outlook_work, personal, gedachten },
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
