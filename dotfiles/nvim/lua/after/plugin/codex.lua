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

vim.keymap.set("n", "<leader>af", codex.send_path, {
    desc = "Send the current path to Codex",
})
vim.keymap.set("n", "<leader>as", function()
    vim.go.operatorfunc = "v:lua.require'helpers.codex'.send_operator"
    return "g@"
end, {
    expr = true,
    desc = "Send a motion or text object to Codex",
})
vim.keymap.set("x", "<leader>as", codex.send_visual, {
    desc = "Send the visual selection to Codex",
})
vim.keymap.set("n", "<leader>aS", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    codex.send_lines(line, line)
end, {
    desc = "Send the current line to Codex",
})
vim.keymap.set("n", "<leader>ac", ":!codex-commit<cr>", {
    desc = "Commit the staged changes using Codex",
})
