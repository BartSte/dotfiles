local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

---Extends the OpenAI adapter.
---@return table The extended OpenAI adapter.
local function openai()
  return require("codecompanion.adapters").extend(
    "openai",
    { schema = { model = { default = "gpt-4o-mini" } } }
  )
end

---Creates a prompt function for a given name.
---@param name string The name of the prompt.
---@return function A function that prompts with the specified name.
local function make_prompt(name)
  return function()
    require("codecompanion").prompt(name)
  end
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

mapper.nnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aid", make_prompt("docstring"))
mapper.vnoremap("<leader>ait", make_prompt("typehint"))

mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
