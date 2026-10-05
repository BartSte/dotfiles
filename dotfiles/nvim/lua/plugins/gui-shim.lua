return {
    'equalsraf/neovim-gui-shim',
    cond = function()
        for _, ui in ipairs(vim.api.nvim_list_uis()) do
            local client = vim.api.nvim_get_chan_info(ui.chan).client or {}
            if client.name and client.name ~= "nvim-tui" then
                return true
            end
        end
        return false
    end,
}
