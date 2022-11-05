local mapper = require('keymapper')
-- Searches directoties upward for a shada file. If found this file can be
-- interpreted as the "project-shada", conainint project specific data. For
-- example, marks. If not found, the global shada file of neovim is used.
vim.go.shadafile = vim.fn.findfile('nvim.shada', '.;')

-- Append 'T with '" ensures that the cursor moves to the last position in the
-- file
mapper.nnoremap("'T", "'T'\"")
mapper.nnoremap("'S", "'S'\"")
mapper.nnoremap("'R", "'R'\"")
mapper.nnoremap("'A", "'A'\"")
mapper.nnoremap("<a-m>", "<cmd>Marks<CR>")
