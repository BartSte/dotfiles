local constants = require("codecompanion.config").config.constants
local helpers = require("helpers.codecompanion.workspace")

return {
    strategy = "chat",
    description = "Generate a Workspace file/group",
    opts = {
        ignore_system_prompt = true,
        auto_submit = true,
        short_name = "workspace",
    },
    references = {
        {
            type = "file",
            path = {
                helpers.find()
            },
        },
    },
    prompts = {
        {
            role = constants.SYSTEM_ROLE,
            opts = { visible = false },
            content = function()
                local schema = require("codecompanion").workspace_schema()
                return string.format(
                    [[## CONTEXT

A workspace is a JSON configuration file that organizes your codebase into related groups to help LLMs understand your project structure. Each group contains files, symbols, or URLs that provide context about specific functionality or features.

The workspace file follows this structure:

```json
%s
```

## OBJECTIVE

Create or modify a workspace file that effectively organizes the user's codebase to provide optimal context for LLM interactions.

## RESPONSE

You must create or modify a workspace file through a series of prompts over multiple turns:

1. First, ask the user about the project's overall purpose and structure if not already known
2. Then ask the user to identify key functional groups in your codebase
3. For each group, ask the user select relevant files, symbols, or URLs to include. Or, use your own knowledge to identify them
4. Generate the workspace JSON structure based on the input
5. Review and refine the workspace configuration together with the user]],
                    schema
                )
            end,
        },
        {
            role = constants.USER_ROLE,
            content = function()
                local prompt = ""
                if vim.fn.filereadable(helpers.find()) == 1 then
                    prompt = [[Can you help me add a group to an existing workspace file?]]
                else
                    prompt = [[Can you help me create a workspace file?]]
                end

                local ok, _ = pcall(require, "vectorcode")
                if ok then
                    prompt = prompt .. " Use the @vectorcode tool to help identify groupings of files"
                end
                return prompt
            end,
        },
    },
}
