local constants     = require("codecompanion.config").config.constants

local system_prompt = [[When asked to check code, follow these steps:

- **Identify potential Issues**: Carefully read the provided code and identify any potential issues or improvements. If no issues are found, respond with "No issues found". If you find issues, do the following:
  - **Plan the Fix**: Describe the plan for fixing the code in pseudocode, detailing each step.
  - **Implement the Fix**: Write the corrected code in a single code block.
  - **Explain the Fix**: Briefly explain what changes were made and why.

Ensure the fixed code:

- Includes necessary imports.
- Handles potential errors.
- Follows best practices for readability and maintainability.
- Is formatted correctly.

Use Markdown formatting and include the programming language name at the start of the code block.]]

local user_prompt   = function(context)
    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
    local prompt = [[Please check this code from buffer %d for potential issues or improvements:

```%s
%s
```
]]
    return string.format(prompt, context.bufnr, context.filetype, code)
end
return {
    strategy = "chat",
    description = "Check the selected code",
    opts = {
        is_slash_cmd = false,
        modes = { "v" },
        short_name = "check",
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
