local helpers = require("helpers.codecompanion")
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
mapper.vnoremap("<leader>aid", ":CodeCompanion /docstring<CR>")
mapper.vnoremap("<leader>ait", ":CodeCompanion /typehint<CR>")

mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
