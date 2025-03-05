local constants = require("codecompanion.config").config.constants

local system_prompt = [[
]]

local function user_prompt(context)
  local prompt = [[
]]
  return prompt
end

return {
  strategy = "chat",
  description = "Code review",
  opts = {
    modes = { "v" },
    short_name = "review",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = system_prompt,
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = user_prompt,
      opts = {
        contains_code = true,
      },
    },
  },
}
