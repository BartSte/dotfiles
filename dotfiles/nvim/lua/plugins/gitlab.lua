return {
  "BartSte/gitlab.vim",
  cond = function()
    return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ''
  end,
  config = function()
    require("config.gitlab")
  end
}
