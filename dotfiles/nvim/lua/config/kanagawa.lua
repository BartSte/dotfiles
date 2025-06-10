local kanagawa = require("kanagawa")
local colors = require("helpers.colors")
local default_dragon = require("kanagawa.colors").setup({ theme = "dragon" })
local m = require("helpers.keymapper")
local saturation = 3
local light_delta = 0.08

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
        palette = colors.boost_palette(default_dragon.palette, saturation, light_delta),
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

-- -- Boost the default dragon plalette by the curent saturation value + 0.1.
-- local saturation_notify_opts = {
--     title = "Colorscheme saturation",
--     id = "saturation_boost"
-- }
-- local function set_palette_saturation(value)
--     if value < 0 then
--         Snacks.notify("Saturation value must be greater than 0", saturation_notify_opts)
--         return
--     end
--     saturation = value
--     local new_palette = colors.boost_palette(default_dragon.palette, saturation, light_delta)
--     kanagawa.setup({ colors = { palette = new_palette } })
--     kanagawa.load()
--     Snacks.notify("Saturation set to: " .. value, saturation_notify_opts)
-- end
--
-- local light_delta_notify_opts = {
--     title = "Colorscheme light delta",
--     id = "light_delta_change"
-- }
-- local function set_palette_light_delta(value)
--     if value < 0 then
--         Snacks.notify("Light delta value must be greater than 0", light_delta_notify_opts)
--         return
--     end
--     light_delta = value
--     local new_palette = colors.boost_light_delta(default_dragon.palette, saturation, light_delta)
--     kanagawa.setup({ colors = { palette = new_palette } })
--     kanagawa.load()
--     Snacks.notify("Light delta set to: " .. value, light_delta_notify_opts)
-- end
--
-- local mappings_enabled = false
-- -- when hitting <leader>cb enable the following mappings:
-- -- s -> set_palette_saturation(saturation + 0.1)
-- -- S -> set_palette_saturation(saturation - 0.1)
-- -- l -> set_palette_light_delta(light_delta + 0.01)
-- -- L -> set_palette_light_delta(light_delta - 0.01)
-- -- when hitting it again, it should disable the mappings again and restore any
-- -- previous mapping on s, S, l, and L.
-- -- also notify the user that mappings are enabled/disabled
-- local function saturation_toggle_mapping()
--     if not mappings_enabled then
--         mappings_enabled = true
--         Snacks.notify("Saturation mappings enabled", saturation_notify_opts)
--         local prev_s_mapping = vim.api.nvim_replace_termcodes("s", true, false, true)
--         local prev_S_mapping = vim.api.nvim_replace_termcodes("S", true, false, true)
--         local prev_l_mapping = vim.api.nvim_replace_termcodes("l", true, false, true)
--         local prev_L_mapping = vim.api.nvim_replace_termcodes("<leader>L", true, false, true)
--         m.nnoremap("s", function() set_palette_saturation(saturation + 0.1) end)
--         m.nnoremap("S", function() set_palette_saturation(saturation - 0.1) end)
--         m.nnoremap("l", function() set_palette_light_delta(light_delta + 0.01) end)
--         m.nnoremap("L", function() set_palette_light_delta(light_delta - 0.01) end)
--     else
--         mappings_enabled = false
--         Snacks.notify("Saturation mappings disabled", saturation_notify_opts)
--         vim.api.nvim_del_keymap("n", "<leader>s")
--         vim.api.nvim_del_keymap("n", "<leader>S")
--         vim.api.nvim_del_keymap("n", "<leader>l")
--         vim.api.nvim_del_keymap("n", "<leader>L")
--         vim.api.nvim_set_keymap("n", "<leader>s", prev_s_mapping, { noremap = true, silent = true })
--         vim.api.nvim_set_keymap("n", "<leader>S", prev_S_mapping, { noremap = true, silent = true })
--         vim.api.nvim_set_keymap("n", "<leader>l", prev_l_mapping, { noremap = true, silent = true })
--         vim.api.nvim_set_keymap("n", "<leader>L", prev_L_mapping, { noremap = true, silent = true })
--     end
-- end
--
-- m.nnoremap("<leader>cb", saturation_toggle_mapping, { noremap = true, silent = true })
