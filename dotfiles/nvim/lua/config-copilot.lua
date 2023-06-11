local copilot = require("copilot")

copilot.setup({
    panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
        },
        layout = {
            position = "right",     -- | top | left | right
            ratio = 0.4
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept = "<M-i>",
            dismiss = "<M-m>",
            accept_word = "<M-I>",
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
    copilot_node_command = 'node',     -- Node.js version must be > 16.x
    server_opts_overrides = {},
})
