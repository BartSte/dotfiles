local p = require("helpers.path")
local workspace = require("codecompanion.strategies.chat.slash_commands.workspace")

---Manages workspace configurations for CodeCompanion
---@class helpers.CodeCompanion.Workspace
---@field find fun(dir: string|nil): string
---@field patch_workspace_file_path fun(str_or_func: string|fun(): string)
local M = {}

---Finds the workspace configuration file that is located in `dir` and has the
---same name as the current directory.
---@param dir string|nil The directory to search for workspace configuration.
---Defaults to the `workspaces` directory in the nvim config directory.
---@return string # Full path to workspace configuration file
function M.find(dir)
    dir = dir or p.join(vim.fn.stdpath("config"), "workspaces")
    local base = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local name = base .. ".json"
    return p.join(dir, name)
end

---Sets the workspace file path or a function to retrieve it
---@param str_or_func string|fun(): string Path string or function returning path
function M.patch_workspace_file_path(custom_path)
    local old_func = workspace.read_workspace_file
    workspace.read_workspace_file = function(SlashCommand, path)
        if type(custom_path) == "function" then
            custom_path = custom_path()
        end

        if p.exists(custom_path) then
            path = custom_path
        end

        return old_func(SlashCommand, path)
    end
end

return M
