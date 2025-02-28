local user_prompt = [[
<user_prompt>
I have the following code:
```
%s
%s
```
Add new docstrings to the code if there are none. Replace exising docstrings if
they are already provided.
%s
%s
</user_prompt>
]]

local format = {
  python = "Google Docstrings",
  lua = "LuaCATS"
}

local function get_format(context)
  if not format[context.filetype] then return "" end
  return string.format("Format your docstrings as per the %s style.", format[context.filetype])
end

local examples = {}

examples.python = [[
def add(a: int, b: int) -> int:
  """Adds two numbers.

  Args:
      a: the first number.
      b: the second number.

  Returns:
      Sum of the two numbers.

  """
]]

examples.lua = [[
---A point with (x, y) coordinates.
---@class Point
---@field x number
---@field y number
local Point = {x=0, y=0}

---Make a point.
---@param x number
---@param y number
---@return Point result A point containing x, y coordinates
local function Point.new(x, y)
  return { x=x, y=y }
end
]]

local function get_example(context)
  if not examples[context.filetype] then return "" end
  local template = "\nFor example:\n\n```%s\n```\n"
  return string.format(template, examples[context.filetype])
end

return {
  strategy = "inline",
  description = "Write docstrings",
  opts = {
    modes = { "v" },
    auto_submit = true,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = function(context)
        return "Act as a senior " .. context.filetype .. " developer."
      end,
    },
    {
      role = "user",
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        local result = user_prompt.format(user_prompt, context.filetype, code, get_format(context), get_example(context))
        dd(result)
        return result
      end,
      opts = {
        contains_code = true,
      }
    }
  }
}
