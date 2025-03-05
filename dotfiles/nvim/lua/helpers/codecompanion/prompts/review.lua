local constants = require("codecompanion.config").config.constants

local function system_prompt(context)
  local prompt = [[
Act as a senior %s engineer that is an expert in doing code reviews. During a
code review follow general best-practices when programming in the %s language.
Generally, the following topics should be part of the "best-practices", though
code review should not be limited to this list only:

- Point out invalid syntax and bugs
- Readability and maintainability
- Performance and efficiency

Present you review as a list of bullets. If needed, you can use example code to
make you review more clear.

If you don't find anything noteworthy, youcan answer with "looks good to me!".
]]
end

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
