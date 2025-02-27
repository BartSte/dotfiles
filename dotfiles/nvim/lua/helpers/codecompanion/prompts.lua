---@class Prompts
---@field docstrings table
---@field typehints table
local M = {}

local function get_format(filetype)
  local formats = {
    python = "Google Docstrings",
    lua = "LuaCATS"
  }
  local default = "that is most common for " .. filetype
  return formats[filetype] or default
end

M.docstring = {
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
        return [[
          <user_prompt>
          I have the following code:
          ```
          ]] .. context.filetype .. "\n" .. code .. [[
          ```
          Add docstring to this code in the format
          ]] .. get_format(context.filetype) .. [[.
          <user_prompt>
        ]]
      end,
      opts = {
        contains_code = true,
      }
    }
  }
}

M.typehint = {
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


return M
