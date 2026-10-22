local helpers = require("helpers.lualine")
local icons = require("nvim-web-devicons")
local lualine = require("lualine")
local projectmarks = require("projectmarks.lualine")

local venv = {
    helpers.venv,
    icon = {
        icons.get_icon_by_filetype("python", {}),
        color = { fg = require("kanagawa.colors").setup().theme.syn.identifier }
    },
}

local filename = {
    "filename",
    path = 1,
    symbols = {
        modified = " [+]",
        readonly = " [RO]"
    }
}

local fileformat = {
    "fileformat",
    cond = function() return vim.bo.fileformat ~= "unix" end,
    symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
    icons_enabled = false,
    padding = { left = 1, right = 2 }
}

local location = {
    "location",
}

local projectrc = {
    function() return require("projectrc").get_name() end,
    cond = function() return require("projectrc").get_name() ~= "" end,
    icon = "",
}

-- Regenerate colors on colorscheme changes; only the mode gets a filled accent.
local function statusline_theme()
    local theme = require("kanagawa.colors").setup().theme
    local result = {}
    local modes = {
        normal = theme.syn.string,
        insert = theme.syn.fun,
        command = theme.syn.identifier,
        visual = theme.syn.keyword,
        replace = theme.syn.operator,
        terminal = theme.syn.special1,
        inactive = theme.ui.special,
    }
    for mode, accent in pairs(modes) do
        local flat = { fg = theme.ui.fg, bg = theme.ui.bg_p1 }
        result[mode] = {
            a = { fg = theme.ui.bg, bg = accent, gui = "bold" },
            b = vim.deepcopy(flat),
            c = vim.deepcopy(flat),
            x = vim.deepcopy(flat),
            y = vim.deepcopy(flat),
            z = vim.deepcopy(flat),
        }
    end
    return result
end

lualine.setup({
    options = {
        icons_enabled = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        theme = statusline_theme,
    },
    sections = {
        -- State of the editor
        lualine_a = { "mode" },

        -- Same for all files
        lualine_b = { projectmarks.shada, projectrc, venv },

        -- Changes when switching buffers
        lualine_c = { filename, "branch", "diff", "diagnostics", projectmarks.marks_optimized },
        lualine_x = { "filetype", fileformat },

        -- Same for all files
        lualine_y = { { helpers.tabs, cond = function() return vim.fn.tabpagenr("$") > 1 end } },

        -- State of the editor
        lualine_z = { location }
    },
    extensions = { "fugitive", "fzf", "quickfix", "lazy", "mason", "oil" }
})
vim.opt.showtabline = 0
