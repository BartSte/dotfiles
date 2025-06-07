local defaults          = require("gitlab.config.defaults")
local gitlab            = require("gitlab")
local mapper            = require("helpers.keymapper")

local default_filetypes = defaults.code_suggestions.auto_filetypes
local auto_filetypes    = { "lua", "markdown", "zsh", "bash", "toml", "yaml", "json" }
vim.list_extend(auto_filetypes, default_filetypes)
vim.schedule(function()
    require("helpers.rbw").set_env("gitlabtoken", "GITLAB_TOKEN")
end)

gitlab.setup({
    code_suggestions = {
        auto_filetypes = auto_filetypes,
        ghost_text = {
            enabled = true,
            accept_suggestion = '<Right>',
            clear_suggestions = '<Left>',
            insert_word = "<C-Right>",
            restore_word = "<C-Left>",
            insert_line = "<S-Right>",
            restore_line = "<S-Left>",
            stream = false,
        },
    },
    minimal_message_level = vim.lsp.log_levels.ERROR,
    resource_editing = {
        enabled = true,
    },
    statusline = {
        enabled = require("helpers.lualine.gitlab").state.set
    },
})

mapper.nnoremap("<leader>ac", ":GitLabCodeSuggestionsStart<CR>")
