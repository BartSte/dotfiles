vim.cmd.packadd("nvim.undotree")

vim.keymap.set("n", "<M-u>", "<Cmd>Undotree<CR>")
vim.keymap.set("n", "<M-U>", function()
    local winid = vim.b.nvim_undotree
    if winid and vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_set_current_win(winid)
    end
end)
