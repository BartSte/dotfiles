require("kanagawa").setup({
    compile = false,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,   -- keep Dragon's warm charcoal background
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        -- Boost chromatic Dragon colors only: 1.5x HSL saturation, +0.04 lightness.
        -- Keep neutral text and background colors at their original values.
        palette = {
            dragonGreen = "#8bb98b",
            dragonGreen2 = "#94aa7f",
            dragonPink = "#af99b0",
            dragonOrange = "#cb9a7b",
            dragonOrange2 = "#ce937a",
            dragonViolet = "#8e9ab6",
            dragonRed = "#dd7169",
            dragonAqua = "#94b2af",
            dragonTeal = "#99a7c5",
            dragonYellow = "#d8c08b",
            dragonBlue2 = "#8fb0c1",
        },
        theme = {
            dragon = {
                syn = {
                    -- Keep comments readable independently of syntax accents.
                    comment = "#9e9b93", -- dragonGray2
                },
            },
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
            NormalFloat = { fg = theme.ui.fg, bg = theme.ui.bg_m1 },
            FloatBorder = { fg = theme.ui.special, bg = theme.ui.bg_m1 },
            FloatTitle = { fg = theme.syn.identifier, bg = theme.ui.bg_m1, bold = true },
            Pmenu = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = theme.ui.bg, bg = theme.syn.string, bold = true },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            WinSeparator = { fg = theme.ui.special },
            Comment = { fg = theme.syn.comment, italic = true },
            Folded = { fg = theme.syn.comment, bg = theme.ui.bg_p1 },
            LineNr = { fg = theme.ui.special },
            CursorLineNr = { fg = theme.syn.identifier, bold = true },
            CopilotSuggestion = { fg = theme.ui.special, italic = true },
            FlashLabel = { fg = theme.ui.bg, bg = theme.syn.identifier, bold = true },
            HighlightedyankRegion = { fg = theme.ui.bg, bg = theme.syn.string },
            TreesitterContext = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
            TreesitterContextLineNumber = { fg = theme.ui.special, bg = theme.ui.bg_p1 },
            TreesitterContextSeparator = { fg = theme.ui.bg_p2, bg = theme.ui.bg },
        }
    end,
    theme = "dragon",
    background = { dark = "dragon", light = "lotus" },
})
