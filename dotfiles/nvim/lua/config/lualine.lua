local lualine = require('lualine')
local custom_auto = require('lualine.themes.auto')

custom_auto.inactive.c.fg = '#BBBBBB'
custom_auto.inactive.c.bg = nil
custom_auto.inactive.c.gui = 'bold'

lualine.setup({
    options = {
        icons_enabled = false,
        theme = custom_auto,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = false,
        refresh = {
            statusline = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'fugitive', 'fzf', 'quickfix' }
})

lualine.hide({
    place = {'tabline', 'winbar'},
})
