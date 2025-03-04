local constants = require("codecompanion.config").config.constants

local system_prompt = [[
Act as a senior software engineer that is an expert in version control with git.
You are finishing a piece of code and need to summarize all changes as entries
in a CHANGLOG file.
]]

local template = [[
Summarize the output of the "git diff %s" and the "git log %s..HEAD" commands on
a git repository. The summary must be suitable for an entry in a changelog file.
Do not provide any other text than theses bullet points.

The output of the "git diff %s" command is:
```
%s
```

The output of the "git log %s..HEAD" command is:
```
%s
``

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
      content = system_prompt
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local branch = vim.fn.input("Branch: ")
        if not branch then
          Snacks.notify.error("No branch provided")
          return
        end

        local diff = vim.fn.system("git diff " .. branch)
        local log = vim.fn.system("git log " .. branch .. "..HEAD")
        if not diff or not log then
          Snacks.notify.error("Failed to get diff and/or log for " .. branch)
          return
        end

        return string.format(template, branch, branch, branch, diff, branch, log)
      end,
    }
  }
}
