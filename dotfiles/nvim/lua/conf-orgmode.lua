local orgmode = require('orgmode')
local bullets = require('org-bullets')

orgmode.setup_ts_grammar()

orgmode.setup({
  org_agenda_files = {'~/Dropbox/Notes/*', '~/Dropbox/Recepten/*'},
  org_default_notes_file = '~/Dropbox/Notes/main.org',
})

bullets.setup({})
