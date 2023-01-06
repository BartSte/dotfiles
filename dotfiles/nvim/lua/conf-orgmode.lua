local mapper = require('keymapper')
local orgmode = require('orgmode')
local os_path = require('os_path')
local bullets = require('org-bullets')
local khal_export = require('khal-export').export

--- For org + wsl, windows $USERPROFILE is used as home and is captured by the
--environment variable $WH (Windows Home).
local function get_home()
    local wsl_home = os.getenv('WH')
    if (wsl_home) then
        return wsl_home
    elseif vim.fn.has('win32') then
        return os.getenv('USERPROFILE')
    else
        return os.getenv('HOME')
    end
end

local custom_exports = {
    v = {
        label = 'Export to khal',
        action = khal_export
    }
}

local dropbox_home = os_path.path_join(get_home(), 'Dropbox')
local dropbox_org = os_path.path_join(dropbox_home, 'org')
local dropbox_agenda = os_path.path_join(dropbox_home, 'org', 'outlook.org')
local dropbox_main = os_path.path_join(dropbox_home, 'org', 'main.org')

orgmode.setup_ts_grammar()

orgmode.setup({
    org_default_notes_file = dropbox_main,
    org_agenda_files = dropbox_agenda,
    org_todo_keywords = { 'TODO', 'WAIT', 'MEET', 'JIRA', 'NEXT', 'HOLD', '|', 'DONE', 'CANCEL' },
    org_blank_before_new_entry = { heading = true, plain_list_item = false },
    org_hide_emphasis_markers = true,
    org_custom_exports = custom_exports,
    win_split_mode = 'vertical'
})

bullets.setup({
    checkboxes = {
        done = { "✓", "OrgDone" },
        todo = { "˟", "OrgTODO" },
    }
})
mapper.nnoremap('<a-r>', ':Files ' .. dropbox_org .. '<CR>')
