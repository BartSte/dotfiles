local companion = require("codecompanion")
local helpers = require("helpers.codecompanion")
local mapper = require("helpers.keymapper")

local opts = {
  adapters = helpers.adapters,
  prompt_library = helpers.prompts,
  strategies = {
    chat = {
      keymaps = {
        regenerate = { modes = { n = "<leader>ar" } },
      }
    },
    inline = {
      keymaps = {
        accept_change = { modes = { n = "<leader>aa" } },
        reject_change = { modes = { n = "<leader>ar" } },
      },
    },
  },
}

local host_opts = helpers.require_by_hostname("config.codecompanion")
opts = vim.tbl_deep_extend("force", opts, host_opts)
companion.setup(opts)

---Creates a prompt function for a given name.
---@param name string The name of the prompt.
---@return function A function that prompts with the specified name.
local function make_prompt(name)
  return function() companion.prompt(name) end
end

mapper.nnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aI", ":CodeCompanion ")
mapper.vnoremap("<leader>aid", make_prompt("docstring"))
mapper.vnoremap("<leader>ait", make_prompt("typehint"))

mapper.nnoremap("<leader>aC", ":CodeCompanionChat Toggle<CR>")
mapper.vnoremap("<leader>aC", ":CodeCompanionChat ")

mapper.nnoremap("<leader>a:", ":CodeCompanionCmd ")
mapper.nnoremap("<leader>a?", helpers.notify.default_models)
