local fmt = string.format
local constants = require("codecompanion.config").config.constants

return {
    strategy = "chat",
    description = "Explain the LSP diagnostics for the selected code",
    opts = {
        modes = { "v" },
        short_name = "lsp",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
    },
    prompts = {
        {
            role = constants.SYSTEM_ROLE,
            content =
            [[You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages. When appropriate, give solutions with code snippets as fenced codeblocks with a language identifier to enable syntax highlighting.]],
            opts = {
                visible = false,
            },
        },
        {
            role = constants.USER_ROLE,
            content = function(context)
                local diagnostics = require("codecompanion.helpers.actions").get_diagnostics(
                    context.start_line,
                    context.end_line,
                    context.bufnr
                )

                local concatenated_diagnostics = ""
                for i, diagnostic in ipairs(diagnostics) do
                    concatenated_diagnostics = concatenated_diagnostics
                        .. i
                        .. ". Issue "
                        .. i
                        .. "\n  - Location: Line "
                        .. diagnostic.line_number
                        .. "\n  - Buffer: "
                        .. context.bufnr
                        .. "\n  - Severity: "
                        .. diagnostic.severity
                        .. "\n  - Message: "
                        .. diagnostic.message
                        .. "\n"
                end

                return fmt(
                    [[The programming language is %s. This is a list of the diagnostic messages:

%s
]],
                    context.filetype,
                    concatenated_diagnostics
                )
            end,
        },
        {
            role = constants.USER_ROLE,
            content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(
                    context.start_line,
                    context.end_line,
                    { show_line_numbers = true }
                )
                return fmt(
                    [[
This is the code, for context:

```%s
%s
```
]],
                    context.filetype,
                    code
                )
            end,
            opts = {
                contains_code = true,
            },
        },
    },
}
