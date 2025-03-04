local adapters = require("codecompanion.adapters")

--- Creates and returns an OpenAI adapter configuration
---@param opts? table Optional table of options to merge into the adapter
---@return table adapter The configured OpenAI adapter table
local function make_openai(opts)
  local adapter = adapters.extend(
    "openai",
    {
      env = {
        api_key = "cmd: rbw get openai_token"
      },
      schema = {
        model = {
          choices = {
            "o1-mini",
            "gpt-4o-mini",
          },
        }
      },
      temperature = {
        default = 0,
        desc = "0 is for coding, 2 is creative writing",
        validate = function(n)
          return n >= 0 and n <= 2, "Must be between 0 and 2"
        end,
      }
    }
  )
  adapter = vim.tbl_deep_extend('force', adapter, opts)
  return adapter
end

--- Creates a Deepseek adapter configuration, optionally merging with provided options
---@param opts? table Optional table of options to merge into the adapter
---@return table adapter The merged Deepseek adapter configuration
local function make_deepseek(opts)
  opts = opts or {}
  local adapter = adapters.extend(
    "deepseek", {
      env = {
        api_key = "cmd: rbw get deepseektoken"
      },
      temperature = {
        default = 0,
        desc = "0 is for coding, 1.5 is creative writing",
        validate = function(n)
          return n >= 0 and n <= 1.5, "Must be between 0 and 1.5"
        end,
      }
    })
  adapter = vim.tbl_deep_extend('force', adapter, opts)
  return adapter
end

---@class CodeCompanionAdapters
---@field openai CodeCompanion.Adapter
---@field deepseek CodeCompanion.Adapter
---@field deepseek_chat CodeCompanion.Adapter
local M = {
  openai_4o = make_openai({ name = "openai_4o", schema = { model = { default = "gpt-4o-mini" } } }),
  openai_o1 = make_openai({ name = "openai_o1", schema = { model = { default = "o1-mini" } } }),
  deepseek = make_deepseek(),
  deepseek_chat = make_deepseek({ name = "deepseek_chat", schema = { model = { default = "deepseek-chat" } } }),
}

return M
