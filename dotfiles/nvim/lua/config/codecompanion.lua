local cc = require("codecompanion")
local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

local function openai()
  return require("codecompanion.adapters").extend(
    "openai",
    { schema = { model = { default = "gpt-4o-mini" } } }
  )
end


cc.setup({
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
  },
  prompt_library = helpers.prompts
})

local function make_prompt(name)
  return function() cc.prompt(name) end
end

mapper.nnoremap("<leader>ai", ":CodeCompanion ")
mapper.vnoremap("<leader>ai", ":CodeCompanion ")
mapper.nnoremap("<leader>ac", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>ac", ":CodeCompanionChat ")
mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
mapper.vnoremap("<leader>apd", make_prompt("docstring"))
mapper.vnoremap("<leader>appt", make_prompt("typehint"))
