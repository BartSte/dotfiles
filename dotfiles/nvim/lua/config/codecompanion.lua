local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

local function openai()
  return require("codecompanion.adapters").extend(
    "openai",
    { schema = { model = { default = "gpt-4o-mini" } } }
  )
end

local function make_prompt(name)
  return function() require("codecompanion").prompt(name) end
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
      adapter = "openai",
      keymaps = {
        accept_change = {
          modes = { n = "<leader>aa" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "<leader>ar" },
          description = "Reject the suggested change",
        },
      },
    },
    cmd = {
      adapter = "openai",
    }
  },
  prompt_library = helpers.prompts
})

mapper.nnoremap("<leader>ai", ":CodeCompanion ")
mapper.vnoremap("<leader>ai", ":CodeCompanion ")
mapper.nnoremap("<leader>ac", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>ac", ":CodeCompanionChat ")
mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
mapper.vnoremap("<leader>apd", make_prompt("docstring"))
mapper.vnoremap("<leader>apt", make_prompt("typehint"))
