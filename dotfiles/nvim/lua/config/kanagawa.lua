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
        palette = colors.boost_palette(default_dragon.palette, saturation),
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
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
