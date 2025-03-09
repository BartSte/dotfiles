local companion = require("codecompanion")
local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

local opts = {
    adapters = helpers.adapters,
    prompt_library = helpers.prompts,
    display = {
        action_palette = {
            opts = {
                show_default_actions = false,        -- Show the default actions in the action palette?
                show_default_prompt_library = false, -- Show the default prompt library in the action palette?
            },
        },
        chat = {
            intro_message = "Press ? for options",
            ---@param tokens string
            ---@param adapter CodeCompanion.Adapter
            ---@return string The string to display
            token_count = function(tokens, adapter) -- The function to display the token count
                return string.format("%s tokens @%s", tokens, adapter.name)
            end,
        }
    },
    strategies = {
        chat = {
            keymaps = {
                regenerate = { modes = { n = "<leader>agr" } },
                close = { modes = { n = "<leader>qc", i = "<C-x>q", } },
            },
        },
        inline = {
            keymaps = {
                accept_change = { modes = { n = "<leader>aa" } },
                reject_change = { modes = { n = "<leader>ar" } },
            },
        },
    },
}

-- Add host specific adapters
---@type table
local host_opts = helpers.require_by_hostname("config.codecompanion")
opts = vim.tbl_deep_extend("force", opts, host_opts)
companion.setup(opts)

---Creates a prompt function for a given name.
---@param name string The name of the prompt.
---@return function A function that prompts with the specified name.
local function make_prompt(name)
    return function() companion.prompt(name) end
end

mapper.nnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aca", ":CodeCompanion Add<CR>")
mapper.vnoremap("<leader>aid", make_prompt("docstring"))
mapper.vnoremap("<leader>ait", make_prompt("typehint"))
mapper.vnoremap("<leader>air", make_prompt("refactor"))
mapper.vnoremap("<leader>aiu", make_prompt("unittest"))

mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")
mapper.nnoremap("<leader>acc", make_prompt("commit"))
mapper.nnoremap("<leader>acd", make_prompt("changes"))
mapper.vnoremap("<leader>ace", make_prompt("explain"))
mapper.vnoremap("<leader>acF", make_prompt("fix"))
mapper.vnoremap("<leader>acf", make_prompt("check"))
mapper.vnoremap("<leader>acl", make_prompt("lsp"))
mapper.vnoremap("<leader>acr", make_prompt("review"))

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
mapper.nnoremap("<leader>a?", helpers.notify.default_models)

mapper.nnoremap("<leader>aA", ":CodeCompanionActions<CR>")
