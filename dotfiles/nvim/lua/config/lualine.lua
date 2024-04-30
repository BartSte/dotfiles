local lualine = require("lualine")
local custom_auto = require('lualine.themes.auto')

custom_auto.inactive.c.bg = nil
custom_auto.inactive.c.gui = nil

local function tabs()
    local current_tab = vim.fn.tabpagenr()
    local number_of_tabs = vim.fn.tabpagenr('$')
    if number_of_tabs > 1 then
        return string.format('%d/%d', current_tab, number_of_tabs)
    else
        return ''
    end
end

lualine.setup({
    options = {
        icons_enabled = true,
        theme = custom_auto,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
            statusline = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'copilot' },
        lualine_x = {
            {
                'filename',
                path = 4,
            },
            'filetype',
            'fileformat',
        },
        lualine_y = {},
        lualine_z = { 'progress', tabs }
    },
    extensions = { 'fugitive', 'fzf', 'quickfix', "lazy", "mason", "oil" }
})

vim.opt.showtabline = 0
