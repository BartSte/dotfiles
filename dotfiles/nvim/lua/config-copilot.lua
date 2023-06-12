local copilot = require("copilot")
local suggestion = require("copilot.suggestion")
local keymapper = require("keymapper")

local function is_at_end_of_line()
    return vim.fn.col(".") == vim.fn.col("$")
end

-- Execute `func` if the cursor is at the end of the line, after this and feed the `key`.
local function execute_at_eol(callback, key)
    if is_at_end_of_line() then
        callback()
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

copilot.setup({
    panel = { enabled = false },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept_line = false,
            next = "<C-n>",
            prev = "<C-p>",
            toggle_auto_trigger = "<M-Space>"
        },
    },
    filetypes = {
        lua = true,
        python = true,
        zsh = true,
        bash = true,
        sh = true,
        cpp = true,
        vim = true,
        mail = true,
        ["*"] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {},
})

keymapper.inoremap("<Right>", function() execute_at_eol(suggestion.accept, "<Right>") end)
keymapper.inoremap("<Left>", function() execute_at_eol(suggestion.dismiss, "<Left>") end)
keymapper.inoremap("<C-Right>", function() execute_at_eol(suggestion.accept_word, "<C-Right>") end)
