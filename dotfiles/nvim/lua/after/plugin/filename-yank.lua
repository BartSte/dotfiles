vim.api.nvim_create_user_command("FilenameToClipboard", function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg("+", filename)
end, {})
