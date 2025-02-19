local commands          = require("gitlab.commands")
local defaults          = require("gitlab.config.defaults")
local gitlab            = require("gitlab")
local mapper            = require("helpers.keymapper")

local default_filetypes = defaults.code_suggestions.auto_filetypes
local auto_filetypes    = { "lua", "markdown", "zsh", "sh", "toml", "yaml" }
vim.list_extend(auto_filetypes, default_filetypes)

gitlab.setup({
    code_suggestions = {
        auto_filetypes = auto_filetypes,
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
commands.create() -- Needed to reset the `FileType` autocommand.
mapper.inoremap("<C-Right>", require("gitlab.ghost_text").insert_word)
mapper.inoremap("<S-Right>", require("gitlab.ghost_text").insert_line)
