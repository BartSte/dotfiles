local codex = require("helpers.codex")

vim.api.nvim_create_user_command("CodexSend", function(args)
    if args.range == 0 then
        codex.send_path()
        return
    end
    codex.send_lines(args.line1, args.line2)
end, {
    desc = "Send a path or line range to a Codex tmux pane",
    range = true,
})

vim.keymap.set("n", "<leader>as", codex.send_path, {
    desc = "Send the current path to Codex",
})
vim.keymap.set("x", "<leader>as", codex.send_visual, {
    desc = "Send the visual selection to Codex",
})
