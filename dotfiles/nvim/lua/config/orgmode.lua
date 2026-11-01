local orgmode = require('orgmode')
local path = require('helpers.path')
local khalorg = require('khalorg')

local dropbox_home = path.join(path.home(), 'dropbox')
local dropbox_org = path.join(dropbox_home, 'org')
local main = path.join(dropbox_org, 'main.org')
local personal = path.join(dropbox_org, 'personal.org')
local gedachten = path.join(dropbox_org, 'gedachten.org')
local komeco = path.join(dropbox_org, 'komeco.org')
local data_home = vim.env.XDG_DATA_HOME
if not data_home or data_home == '' then data_home = path.join(path.home(), '.local', 'share') end
local calendar_home = path.join(data_home, 'khalorg')
local agenda_dir = path.join(calendar_home, 'agendas')
local inbox_dir = path.join(calendar_home, 'inbox')
local outlook_personal = path.join(agenda_dir, 'outlook_personal.org')
local outlook_work = path.join(agenda_dir, 'outlook_work.org')
vim.fn.mkdir(inbox_dir, 'p')
khalorg.setup({
    executable = 'khalorg-local',
    calendar = 'outlook_personal',
    write_uid = true,
    calendars = {
        outlook_personal = { org_file = outlook_personal },
        outlook_work = { org_file = outlook_work },
    },
    sync = { start = 'today', stop = '365d', delete_on_sync = false },
})

-- Keep file routing and refresh policy here; the plugin owns calendar operations.
local function calendar_action(method)
    return function()
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t:r')
        local function run(calendar)
            if not calendar then return end
            khalorg[method]({ calendar = calendar, on_complete = function(result)
                if result.code ~= 0 or method == 'list' then return end
                vim.system({ 'mycalsync', '--verbose' }, { text = true }, function(sync_result)
                    vim.schedule(function()
                        if sync_result.code ~= 0 then
                            vim.notify('The local edit remains saved in khal. Outlook sync failed; retry mycalsync, not event creation.\n'
                                .. (sync_result.stderr or ''), vim.log.levels.ERROR)
                        else
                            vim.notify('Local calendars synchronized with Outlook.')
                            vim.cmd('checktime')
                        end
                    end)
                end)
            end })
        end
        if name == 'outlook_personal' or name == 'outlook_work' then
            run(name)
        else
            vim.ui.select({ 'outlook_personal', 'outlook_work' }, { prompt = 'Calendar:' }, run)
        end
    end
end

-- Allow an editable copy, but protect generated files from an accidental :write.
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('LocalCalendarAgendas', { clear = true }),
    pattern = { outlook_personal, outlook_work },
    callback = function(args) vim.bo[args.buf].readonly = true end,
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
    n = { label = 'Create a local calendar event', action = calendar_action('new') },
    e = { label = 'Edit event properties', action = calendar_action('edit') },
    E = { label = 'Edit event properties and dates', action = calendar_action('edit_all') },
    L = { label = 'List calendar events in an editable buffer', action = calendar_action('list') },
    C = { label = 'Choose a calendar to list', action = function() vim.cmd('KhalorgCalendar') end },
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
        template = template_event,
        target = path.join(inbox_dir, 'outlook_personal.org')
    },
    w = {
        description = 'Work event',
        template = template_event,
        target = path.join(inbox_dir, 'outlook_work.org'),
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
