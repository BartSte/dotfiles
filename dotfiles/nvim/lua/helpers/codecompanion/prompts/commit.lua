local fmt = string.format
local constants = require("codecompanion.config").config.constants

return {
  strategy = "chat",
  description = "Generate a commit message",
  opts = {
    index = 10,
    is_slash_cmd = true,
    short_name = "commit",
    auto_submit = true,
  },
  prompts = {
    {
      role = constants.USER_ROLE,
      content = function()
        return fmt(
          [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
          vim.fn.system("git diff --no-ext-diff --staged")
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
