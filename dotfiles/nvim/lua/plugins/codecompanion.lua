return {
  "olimorris/codecompanion.nvim",
  cond = function()
    return require("helpers.rbw").set_env("openai_token", "OPENAI_API_KEY")
  end,
  config = function()
    require("config.codecompanion")
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
