return {
    "ellisonleao/gruvbox.nvim",
    priority = 100,
    config = function()
        require("config.gruvbox")
        vim.cmd("colorscheme gruvbox")
        vim.cmd('runtime vim/colors.vim')
    end
}

-- return {
--     'luisiacc/gruvbox-baby',
--     branch = 'main',
--     priority = 100,
--     config = function()
--         vim.cmd("let g:gruvbox_transparant_mode=0")
--         vim.cmd("let g:gruvbox_baby_string_style='nocombine'")
--         vim.cmd("let g:gruvbox_baby_comment_style='italic'")
--         vim.cmd("let g:gruvbox_baby_keyword_style='italic'")
--         vim.cmd("let g:gruvbox_baby_function_style='bold'")
--         vim.cmd("let g:gruvbox_baby_variable_style='NONE'")
--         vim.cmd("let g:gruvbox_baby_background_color='dark'")
--         vim.cmd("let g:gruvbox_baby_use_original_palette=0")
--         vim.cmd('runtime vim/colors.vim')
--         vim.cmd('colorscheme gruvbox-baby')
--     end
-- }
