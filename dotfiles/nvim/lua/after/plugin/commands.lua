-- This command loads plugins that rely on rbw
vim.api.nvim_create_user_command('LoadRbwPlugins', function()
  require("lazy").load({ plugins = { "gitlab.vim", "codecompanion.nvim" } })
end, {})

