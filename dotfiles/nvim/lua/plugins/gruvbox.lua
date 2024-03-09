-- return {
--     'luisiacc/gruvbox-baby',
--     branch = 'main',
--     priority = 100,
--     config = function()
--         require("config.gruvbox-baby")
--         vim.cmd("runtime vim/config/gruvbox-baby.vim")
--     end
-- }

return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        require("config.gruvbox")
    end
}
