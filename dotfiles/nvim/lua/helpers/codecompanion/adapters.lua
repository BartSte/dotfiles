local M = {}

---Extends the OpenAI adapter.
---@return table The extended OpenAI adapter.
function M.openai()
  return require("codecompanion.adapters").extend(
    "openai",
    {
      schema = {
        model = {
          default = "gpt-4o-mini"
        }
      },
      env = {
        api_key = "cmd: rbw get openai_token"
      },
    }
  )
end

---Extends the DeepSeek adapter.
---@see https://deepseek.com/
---@return table The extended DeepSeek adapter.
function M.deepseek()
  return require("codecompanion.adapters").extend(
    "deepseek",
    {
      schema = {
        model = {
          default = "deepseek-chat",
          choices = {
            "deepseek-chat",
            "deepseek-reasoner"
        }
      },
      env = {
        api_key = "cmd: rbw get deepseektoken"
      },
    }
  )
end

M.hosts_vs_adapter = {
  ["zbook"] = M.openai,
  ["bart-asus"] = M.deepseek,
}

function M.get_by_hostname()
  local hostname = vim.fn.hostname()
  return M.hosts_vs_adapter[hostname]
end
