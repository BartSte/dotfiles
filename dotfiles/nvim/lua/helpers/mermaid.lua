local fn = require("helpers.fn")

local M = {}

--- Build the command arguments for invoking the Mermaid CLI.
--- When exists, a Puppeteer config file at `~/.puppeteer.json` is included
--- which resolves issue https://github.com/mermaid-js/mermaid-cli/issues/440.
---@param source string Absolute path to the Mermaid source file.
---@param destination string Output path for the rendered artifact.
---@return string[] command List of command arguments for `mmdc`.
local function make_command(source, destination)
    local command = { "mmdc", "-i", source, "-o", destination, "--scale", "3" }

    local puppeteer_config = vim.fn.expand("~/.puppeteer.json")
    if vim.fn.filereadable(puppeteer_config) == 1 then
        return vim.list_extend(command, { "-p", puppeteer_config })
    else
        return command
    end
end

--- Render the current Mermaid diagram using `mmdc`.
---@param destination string|nil Optional output path for the rendered file.
---@return nil
function M.render(destination)
    local source = vim.fn.expand("%:p")
    local ext = vim.fn.expand("%:e")

    if ext ~= "mmd" then
        vim.notify("Not an .mmd file", vim.log.levels.WARN)
        return
    end

    vim.cmd("write")

    if not destination or #destination == 0 then
        destination = vim.fn.expand("%:p:r") .. ".svg"
    end
    local command = make_command(source, destination)
    vim.notify(string.format("Command: %s", table.concat(command, " ")), vim.log.levels.DEBUG)
    vim.fn.jobstart(command, {
        on_stdout = function(_, data)
            if not fn.is_empty(data) then
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
        end,
        on_stderr = function(_, data)
            if not fn.is_empty(data) then
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
            end
        end,
        on_exit = function()
            vim.notify("Rendered: " .. destination, vim.log.levels.INFO)
        end,
    })
end

return M
