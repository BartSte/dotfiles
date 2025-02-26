return {
  "BartSte/gitlab.vim",
  cond = function()
    require("helpers.rbw").set_env("gitlabtoken", "GITLAB_TOKEN")
    return (vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= '')
  end,
  config = function()
    require("config.gitlab")
  end
}
