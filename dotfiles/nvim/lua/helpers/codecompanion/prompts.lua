---@class Prompts
---@field docstrings table
---@field typehints table
local Prompts = {}

Prompts.docstring = {
  strategy = "inline",
  description = "Write docstrings for the selected function or class.",
  opts = {
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = "user",
      content = [[
          <user_prompt>
          Add a docstrings for the provided functions and/or classes that are
          part of #buffer. The docstring must be inserted above or below the
          function/class definition depending on the programming language that
          is used. Choose the docstring type that is most commonly used, unless
          the language is specified below:
          - python: Goolge Docstrings
          </user_prompt>
        ]]
    }
  },
}

Prompts.typehint = {
  strategy = "inline",
  description = "Generate type hints for variables, parameters, and return values.",
  opts = {
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = { {
    role = "user",
    content = [[
        <user_prompt>
        Please insert the typehints/type annotations for the selected functions,
        parameters and/or return values that is part of the #buffer. The syntax
        will depend on the programming language. Use the most commonly used type
        annotation unless they are specified below:
        - lua: LuaCATS
        </user_prompt>
      ]]
  }
  }
}


return Prompts
