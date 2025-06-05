return {
    {
        'luisiacc/gruvbox-baby',
        branch = 'main',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_transparant_mode = false
            vim.g.gruvbox_baby_string_style = "nocombine"
            vim.g.gruvbox_baby_comment_style = "italic"
            vim.g.gruvbox_baby_keyword_style = "italic"
            vim.g.gruvbox_baby_function_style = "NONE"
            vim.g.gruvbox_baby_variable_style = "NONE"
            vim.g.gruvbox_baby_background_color = "dark"
            vim.g.gruvbox_baby_use_original_palette = false
        end
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Default options:
            require('kanagawa').setup({
                compile = true,
                colors = {
                    palette = {
                        dragonBlack0 = "#000000",
                        dragonBlack1 = "#050603",
                        dragonBlack2 = "#10100d",
                        dragonBlack3 = "#0b0a0a",
                        dragonBlack4 = "#1b1b1b",
                        dragonBlack5 = "#2c2c2a",
                        dragonBlack6 = "#55524e",
                    },
                },
                theme = "dragon",
                background = {
                    dark = "dragon",
                    light = "lotus"
                },
            })
        end
    }
}
