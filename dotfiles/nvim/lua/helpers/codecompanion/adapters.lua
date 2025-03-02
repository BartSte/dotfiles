local adapters = require("codecompanion.adapters")

local function make_openai()
  return adapters.extend(
    "openai",
    {
      env = {
        api_key = "cmd: rbw get openai_token"
      },
      schema = {
        model = {
          default = "gpt-4o-mini"
        }
      }
    }
  )
end

local function make_deepseek(opts)
  opts = opts or {}
  local adapter = adapters.extend(
    "deepseek", {
      env = {
        api_key = "cmd: rbw get deepseektoken"
      },
    })
  adapter = vim.tbl_deep_extend('force', adapter, opts)
  return adapter
end

return {
  openai = make_openai(),
  deepseek = make_deepseek(),
  deepseek_chat = make_deepseek({
    name = "deepseek_chat",
    schema = { model = { default = "deepseek-chat" } }
  }),
}
