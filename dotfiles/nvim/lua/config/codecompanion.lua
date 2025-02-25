local function openai()
  return require("codecompanion.adapters").extend(
    "openai",
    { schema = { model = { default = "gpt-4o-mini" } } }
  )
end

require("codecompanion").setup({
  adapters = {
    openai = openai,
  },
  strategies = {
    chat = {
      adapter = "openai",
    }
  }
})
