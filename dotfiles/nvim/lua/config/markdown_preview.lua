local platform = require("helpers.platform")
local map = require("helpers.keymapper")
local fn = require("helpers.fn")

--- Set sync scroll option for markdown preview
--- @param value number|nil When nil, toggle the current value.
--- @return nil
local function set_sync_scroll(value)
    local options = vim.g.mkdp_preview_options
    options.disable_sync_scroll = value or (1 - options.disable_sync_scroll)
    vim.g.mkdp_preview_options = options
end

--- Set theme for markdown preview
--- @param value string|nil When nil, toggle between 'dark' and 'light'.
--- @return nil
local function set_theme(value)
    -- local theme = fn.is_empty(value) or (vim.g.mkdp_theme == 'dark' and 'light' or 'dark')
    if fn.is_empty(value) then
        value = vim.g.mkdp_theme == 'dark' and 'light' or 'dark'
    end
    vim.g.mkdp_theme = value
    vim.notify(string.format("Markdown theme: %s", value), vim.log.levels.INFO)
end

vim.g.mkdp_browser = platform.is_linux() and vim.fn.expand("$WINWSLBROWSER") or vim.fn.expand("$BROWSER")
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
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
    disable_sync_scroll = 1,
    sync_scroll_type = 'middle',
    hide_yaml_meta = 1,
    sequence_diagrams = {},
    flowchart_diagrams = {},
    content_editable = false,
    disable_filename = 0,
    toc = {},
}

vim.api.nvim_create_user_command("MarkdownScrollSync", function(opts)
    set_sync_scroll(tonumber(opts.args))
end, {
    nargs = "?",
    complete = "file",
})

vim.api.nvim_create_user_command("MarkdownTheme", function(opts)
    set_theme(opts.args)
end, {
    nargs = "?",
    complete = function() return { "dark", "light" } end
})

map.nnoremap("<leader>mp", "<cmd>MarkdownPreviewToggle<CR>")
map.nnoremap("<leader>ms", "<cmd>MarkdownScrollSync<CR>")
map.nnoremap("<leader>mt", "<cmd>MarkdownTheme<CR>")
