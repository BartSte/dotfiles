local mapper = require("helpers.keymapper")

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
    },
    inline = {
      adapter = "openai"
    }
  }
})
mapper.nnoremap("<leader>A", ":CodeCompanion ")
mapper.vnoremap("<leader>A", ":CodeCompanion ")
