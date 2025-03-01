local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

local adapter = helpers.adapters.get_by_hostname()

require("codecompanion").setup({
  adapters = adapter,
  strategies = {
    chat = { adapter = adapter },
    cmd = { adapter = adapter, }
    inline = {
      adapter = adapter_name,
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
  },
  prompt_library = helpers.prompts
})

---Creates a prompt function for a given name.
---@param name string The name of the prompt.
---@return function A function that prompts with the specified name.
local function make_prompt(name)
  return function()
    require("codecompanion").prompt(name)
  end
end

mapper.nnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aid", make_prompt("docstring"))
mapper.vnoremap("<leader>ait", make_prompt("typehint"))

mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
