local constants = require("codecompanion.config").config.constants

local template = [[
Summarize the diff with branch %s provided below in a couple of bullit points
that are suitable for an entry in a changelog. Do not provide any other text
than theses bullet points.
```
%s
```
]]

return {
  strategy = "chat",
  description = "Summarize changes",
  opts = {
    short_name = "changes",
    modes = { "n" },
    auto_submit = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = "Act as a senior software engineer that has years of experience with git and maintaining repositories.",
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local branch = vim.fn.input("Branch: ")
        local diff = vim.fn.system("git diff " .. branch)
        return string.format(template, branch, diff)
      end,
    }
  }
}
