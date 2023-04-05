-- Searches directoties upward for a shada file. If found this file can be
-- interpreted as the "project-shada", conainint project specific data. For
-- example, marks. If not found, the global shada file of neovim is used.
vim.go.shadafile = vim.fn.findfile('nvim.shada', '.;')
