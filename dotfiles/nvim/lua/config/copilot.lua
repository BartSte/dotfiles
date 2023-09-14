local copilot = require("copilot")
local suggestion = require("copilot.suggestion")
local keymapper = require("helpers.keymapper") 

-- Execetut `callback` if the copilot suggestion is visible.
local function execute_if_suggestion_visible(callback, key)
    if suggestion.is_visible() then
        callback()
    else
        key = vim.api.nvim_replace_termcodes(key, true, true, true)
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

copilot.setup({
    panel = { enabled = false },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept_line = "<C-l>",
            next = "<C-n>",
            prev = "<C-p>",
            toggle_auto_trigger = false
        },
    },
    filetypes = {
        oil = false,
        ["*"] = true,
    },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {},
})
keymapper.inoremap("<Right>", function() execute_if_suggestion_visible(suggestion.accept, "<Right>") end)
keymapper.inoremap("<Left>", function() execute_if_suggestion_visible(suggestion.dismiss, "<Left>") end)
keymapper.inoremap("<C-Right>", function() execute_if_suggestion_visible(suggestion.accept_word, "<C-Right>") end)
keymapper.noremap("<leader>co", ":Copilot enable<CR>")
