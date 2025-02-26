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
    },
    cmd = {
      adapter = "openai",
    }
  }
})
mapper.nnoremap("<leader>ai", ":CodeCompanion ")
mapper.vnoremap("<leader>ai", ":CodeCompanion ")
mapper.nnoremap("<leader>ac", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>ac", ":CodeCompanionChat ")
mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
