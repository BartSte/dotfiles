require('gitlab').setup({
    code_suggestions = {
        auto_filetypes = { "*" },
        ghost_text = {
            enabled = true,
            toggle_enabled = false,
            accept_suggestion = '<Right>',
            clear_suggestions = '<Left>',
            stream = true,
        },
    },
    resource_editing = {
        enabled = true,
    },
    statusline = {
        enabled = false,
    },
})

-- FIX: the auto_filetypes option does not work.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.cmd("GitLabCodeSuggestionsStart")
    end,
})
