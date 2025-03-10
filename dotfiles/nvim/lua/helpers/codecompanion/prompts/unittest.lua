local fmt = string.format
local constants = require("codecompanion.config").config.constants

--- Contains documentation formats for different languages.
--- @class FormatDocstrings
--- @field python string
local extras = {
  python = [[
For Python, make sure you use the TestCase class from the unittest module.
]]
}


local function get_extras(context)
  return extras[context.filetype] or ""
end

return {
  strategy = "chat",
  description = "Generate unit tests for the selected code",
  opts = {
    modes = { "v" },
    short_name = "unittest",
    auto_submit = true,
    user_prompt = false,
    placement = "new",
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[When generating unit tests, follow these steps:

1. Identify the programming language.
2. Identify the purpose of the function or module to be tested.
3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
4. Generate unit tests using an appropriate testing framework for the identified programming language.
5. Ensure the tests cover:
      - Normal cases
      - Edge cases
      - Error handling (if applicable)
6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.
7. Do not comment your code. Instead, write more detailed docstrings.
]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return fmt(
          [[<user_prompt>
Please generate unit tests for this code from buffer %d:

```%s
%s
```

%s
</user_prompt>
]],
          context.bufnr,
          context.filetype,
          code,
          get_extras(context)
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
