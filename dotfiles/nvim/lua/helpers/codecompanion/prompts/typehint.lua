return {
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
