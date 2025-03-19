local defaults          = require("gitlab.config.defaults")
local gitlab            = require("gitlab")
local gitlab_state           = require("helpers.lualine.gitlabstate")

local default_filetypes = defaults.code_suggestions.auto_filetypes
local auto_filetypes    = { "lua", "markdown", "zsh", "bash", "toml", "yaml" }
vim.list_extend(auto_filetypes, default_filetypes)

gitlab.setup({
    code_suggestions = {
        auto_filetypes = auto_filetypes,
        ghost_text = {
            enabled = true,
            toggle_enabled = "<C-b>a",
            accept_suggestion = '<Right>',
            clear_suggestions = '<Left>',
            insert_word = "<C-Right>",
            restore_word = "<C-Left>",
            insert_line = "<S-Right>",
            restore_line = "<S-Left>",
            stream = false,
        },
    },
    minimal_message_level = vim.lsp.log_levels.WARN,
    resource_editing = {
        enabled = true,
    },
    statusline = {
        enabled = gitlab_state.set
    },
})
