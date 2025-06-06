local kanagawa = require("kanagawa")
local colors = require("helpers.colors")
local default_dragon = require("kanagawa.colors").setup({ theme = "dragon" })
local saturation = 3
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
local saturation_notify_opts = {
    title = "Colorscheme saturation",
    id = "saturation_boost"
}
local function set_palette_saturation(value)
    if value < 0 then
        Snacks.notify("Saturation value must be greater than 0", saturation_notify_opts)
        return
    end
    saturation = value
    local new_palette = colors.boost_palette(default_dragon.palette, saturation)
    kanagawa.setup({ colors = { palette = new_palette } })
    kanagawa.load()
    Snacks.notify("Saturation set to: " .. value, saturation_notify_opts)
end

-- add to mapping
m.nnoremap("<M-+>", function() set_palette_saturation(saturation + 0.1) end)
m.nnoremap("<M-->", function() set_palette_saturation(saturation - 0.1) end)
