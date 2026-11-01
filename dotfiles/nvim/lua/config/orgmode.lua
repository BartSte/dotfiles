local orgmode = require('orgmode')
local path = require('helpers.path')
local calendar_bridge = require('config.calendar_bridge')

local dropbox_home = path.join(path.home(), 'dropbox')
local dropbox_org = path.join(dropbox_home, 'org')
local dropbox_generated_org = path.join(dropbox_home, 'generated')
local main = path.join(dropbox_org, 'main.org')
local personal = path.join(dropbox_org, 'personal.org')
local gedachten = path.join(dropbox_org, 'gedachten.org')
local komeco = path.join(dropbox_org, 'komeco.org')
local outlook_personal = path.join(dropbox_generated_org, 'outlook_personal.org')
local outlook_work = path.join(dropbox_generated_org, 'outlook_work.org')
local calendar_drafts = vim.fn.stdpath('state') .. '/calendar-bridge/drafts'
calendar_bridge.setup({
    calendars = {
        outlook_personal = outlook_personal,
        outlook_work = outlook_work,
    },
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

local template_event = table.concat({
    '* %?',
    '  %^{Event date and time}T',
    '  :PROPERTIES:',
    '  :ATTENDEES:',
    '  :LOCATION:',
    '  :ORGANIZER:',
    '  :STATUS:',
    '  :UID:',
    '  :URL:',
    '  :UNTIL:',
    '  :END:',
    '',
}, '\n')

local custom_exports = {
    n = { label = 'Create this draft event through the Pi', action = calendar_bridge.new },
    e = { label = 'Edit a local draft or apply it through the Pi', action = calendar_bridge.edit },
}

local mappings = {
    org = {
        org_return = false,
        org_toggle_checkbox = { '<C-Space>', '<S-F12>' },
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
        description = 'Personal event',
        template = template_event:gsub(':UID:', ':CALENDAR: outlook_personal\n  :UID:'),
        target = calendar_drafts .. '/new-personal.org'
    },
    w = {
        description = 'Work event',
        template = template_event:gsub(':UID:', ':CALENDAR: outlook_work\n  :UID:'),
        target = calendar_drafts .. '/new-work.org',
    }
}

orgmode.setup({
    mappings = mappings,
    org_default_notes_file = main,
    org_agenda_files = { main, outlook_personal, outlook_work, personal },
    org_agenda_span = 'month',
    org_blank_before_new_entry = { heading = true, plain_list_item = false },
    org_highlight_latex_and_related = 'native',
    org_hide_emphasis_markers = true,
    org_custom_exports = custom_exports,
    win_split_mode = 'vertical',
    org_todo_keywords = { 'TODO', 'NEXT', 'ACTIVE', 'WAIT', 'STALE', '|', 'DONE' },
    org_capture_templates = templates,
    org_todo_keyword_faces = {
        ACTIVE = 'foreground cyan :weight bold',
        NEXT = 'foreground yellow :weight bold',
        WAIT = ':foreground orange :weight bold',
        STALE = ':foreground magenta :weight bold',
    },
    org_adapt_indentation = false,
})
