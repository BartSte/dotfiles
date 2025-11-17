local fn = vim.fn

local is_windows = fn.has('win32') == 1 or vim.env.WH ~= nil
vim.g.mkdp_browser = is_windows and [[C:\Program Files\Qutebrowser\qutebrowser.exe]] or fn.expand('$BROWSER')

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ''
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_browserfunc = ''
vim.g.mkdp_markdown_css = ''
vim.g.mkdp_highlight_css = ''
vim.g.mkdp_port = ''
vim.g.mkdp_page_title = '「${name}」'
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_theme = 'dark'

vim.g.mkdp_preview_options = {
    mkit = {},
    katex = {},
    uml = {},
    maid = {},
    disable_sync_scroll = 0,
    sync_scroll_type = 'middle',
    hide_yaml_meta = 1,
    sequence_diagrams = {},
    flowchart_diagrams = {},
    content_editable = false,
    disable_filename = 0,
    toc = {},
}

local M = {}

return M
