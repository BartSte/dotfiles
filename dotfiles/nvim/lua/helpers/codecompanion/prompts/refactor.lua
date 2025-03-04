local constants = require("codecompanion.config").config.constants

local system_prompt = "Act as a senior %s software engineer."

local template = [[
Refactor the following piece of code:
```%s
%s
```
The refactored code must meet the following requirements, ordered in order of
importance:
- encountered bugs are fixed
- the code its functionality does not change
- the code is more readable and easier to understand
- the code is more maintainable
- the code is more efficient and performant
Besides the points above, use the common best-practices refactoring code. If you
encounter code that is good as it is, do not refactor it.
]]

return {
  strategy = "inline",
  description = "Refactor",
  opts = {
    short_name = "refactor",
    modes = { "n" },
    auto_submit = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = function(context)
        return string.format(system_prompt, context.filetype)
      end,
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return string.format(template, context.filetype, code)
      end,
    }
  }
}
