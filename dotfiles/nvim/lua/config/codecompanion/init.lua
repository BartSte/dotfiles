local companion = require("codecompanion")
local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

-- local p = require("helpers.path")
-- local workspace = require("codecompanion.strategies.chat.slash_commands.workspace")
-- local function find_custom_workspace_file()
--     local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
--     return p.join(p.home(), "dotfiles/nvim/workspaces", cwd_name .. ".json")
-- end
--
--
-- local func = workspace.read_workspace_file
-- workspace.read_workspace_file = function(SlashCommand, path)
--     local custom_path = find_custom_workspace_file()
--     if vim.fn.filereadable(path) == 0 and vim.fn.filereadable(custom_path) == 1 then
--         path = custom_path
--     end
--     Snacks.notify("Reading workspace file: " .. (path or "nil"))
--     return func(SlashCommand, path)
-- end

local opts = {
    adapters = helpers.adapters,
    prompt_library = require("config.codecompanion.prompts"),
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
                regenerate = { modes = { n = "<leader>ar" } },
                send = { modes = { n = "<leader>aa", i = "<C-x><C-a>" } },
                stop = { modes = { n = "<leader>aq" } },
                close = { modes = { n = "<leader>qq", i = "<C-x><C-q>" } },
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
local host_opts = helpers.require_by_hostname("config.codecompanion.host_specific")
opts = vim.tbl_deep_extend("force", opts, host_opts)
companion.setup(opts)

---Creates a prompt function for a given name.
---@param name string The name of the prompt.
---@return function A function that prompts with the specified name.
local function make_prompt(name)
    return function() companion.prompt(name) end
end

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
mapper.nnoremap("<leader>a?", helpers.notify.default_models)
mapper.nnoremap("<leader>aA", ":CodeCompanionActions<CR>")
mapper.vnoremap("<leader>aA", ":CodeCompanionActions<CR>")
mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.nnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")
mapper.vnoremap("<leader>aI", ":CodeCompanion ")

mapper.nnoremap("<leader>acc", make_prompt("commit"))
mapper.nnoremap("<leader>acd", make_prompt("changes"))
mapper.vnoremap("<leader>acF", make_prompt("fix"))
mapper.vnoremap("<leader>ace", make_prompt("explain"))
mapper.vnoremap("<leader>acf", make_prompt("check"))
mapper.vnoremap("<leader>acl", make_prompt("lsp"))
mapper.vnoremap("<leader>acr", make_prompt("review"))
mapper.vnoremap("<leader>act", make_prompt("unittest"))
mapper.vnoremap("<leader>aid", make_prompt("docstring"))
mapper.vnoremap("<leader>air", make_prompt("refactor"))
mapper.vnoremap("<leader>ait", make_prompt("typehint"))
