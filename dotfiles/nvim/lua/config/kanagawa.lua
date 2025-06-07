local kanagawa = require("kanagawa")
local colors = require("helpers.colors")
local default_dragon = require("kanagawa.colors").setup({ theme = "dragon" })
local saturation = 3
local ligth_delta = 0.08
local m = require("helpers.keymapper")

kanagawa.setup({
    compile = false,  -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,   -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        palette = colors.boost_palette(default_dragon.palette, saturation, ligth_delta),
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },

            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            WinSeparator = { fg = theme.ui.bg_p2 }
        }
    end,
    theme = "dragon",    -- Load "wave" theme
    background = {       -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus"
    },
})

-- Boost the default dragon plalette by the curent saturation value + 0.1.
local notify_opts = {
    title = "Boost colorscheme",
    id = "kanagawa_boost"
}
local function boost_palette(new_saturation, new_ligth_delta)
    new_saturation = new_saturation or saturation
    new_ligth_delta = new_ligth_delta or ligth_delta
    if new_saturation < 0 then
        Snacks.notify("Saturation value must be greater than 0", notify_opts)
        return
    elseif new_ligth_delta < 0 then
        Snacks.notify("Ligth delta value must be greater than 0", notify_opts)
        return
    end
    saturation = new_saturation
    ligth_delta = new_ligth_delta

    local new_palette = colors.boost_palette(default_dragon.palette, saturation, ligth_delta)
    kanagawa.setup({ colors = { palette = new_palette } })
    kanagawa.load()
    Snacks.notify(string.format("Saturation: %s\nLight delta: %s", saturation, ligth_delta), notify_opts)
end

m.nnoremap("<M-+>", function() boost_palette(saturation + 0.1) end)
m.nnoremap("<M-->", function() boost_palette(saturation - 0.1) end)
m.nnoremap("<M->>", function() boost_palette(saturation, ligth_delta + 0.01) end)
m.nnoremap("<M-<>", function() boost_palette(saturation, ligth_delta - 0.01) end)
