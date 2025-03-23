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

If you don't find anything noteworthy, you can answer with "looks good to me!".
]]
    return string.format(prompt, context.filetype, context.filetype)
end

local function user_prompt(context)
    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
    local prompt = [[
Review the following code:
```%s
%s
```
]]
    return string.format(prompt, context.filetype, code)
end

return {
    strategy = "chat",
    description = "Code review",
    opts = {
        short_name = "review",
        modes = { "v" },
        auto_submit = true,
    },
    prompts = {
        {
            role = constants.SYSTEM_ROLE,
            content = system_prompt,
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
