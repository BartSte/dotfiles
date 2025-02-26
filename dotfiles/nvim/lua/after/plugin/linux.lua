if vim.fn.has('linux') == 1 then
  vim.g.python3_host_prog = '/usr/bin/python3'


  vim.api.nvim_create_user_command("UnlockGitlab", function()
    -- Try to fetch and set the token
    require("helpers.rbw").set_env("gitlabtoken", "GITLAB_TOKEN")
    -- If we have a valid token, force-load the plugin:
    if vim.env.GITLAB_TOKEN and vim.env.GITLAB_TOKEN ~= "" then
      require("lazy").load({ plugins = { "gitlab.vim" } })
      vim.notify("Gitlab.vim loaded!")
    else
      vim.notify("Password manager is still locked or token was not found.")
    end
  end, {})
end
