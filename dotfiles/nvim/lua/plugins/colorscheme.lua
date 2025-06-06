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
            require("config.kanagawa")
        end
    }
}
