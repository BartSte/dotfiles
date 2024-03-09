-- return {
--     'luisiacc/gruvbox-baby',
--     branch = 'main',
--     priority = 100,
--     config = function()
--         require("config.gruvbox-baby")
--     end
-- }

return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        require("config.gruvbox")
    end
}
