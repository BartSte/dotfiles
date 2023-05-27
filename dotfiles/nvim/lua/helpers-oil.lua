local oil = require('oil')
local util = require("oil.util")

local M = {}

--- Borrowed from oil -> lua/actions.lua
---@param args
local function open_cmdline_with_args(args)
    local escaped = vim.api.nvim_replace_termcodes(
        ":" .. args .. string.rep("<Left>", args:len() + 1),
        true,
        false,
        true
    )
    vim.api.nvim_feedkeys(escaped, "n", true)
end

--- Similar to oil-actions open_cmdline. Now, the cmd line contains the
--following line that can be used to rename files.
-- `!mv {entry} {entry}`
M.rename = function()
    local config = require("oil.config")
    local fs = require("oil.fs")
    local entry = oil.get_cursor_entry()
    if not entry then
        return
    end
    local bufname = vim.api.nvim_buf_get_name(0)
    local scheme, path = util.parse_url(bufname)
    if not scheme then
        return
    end
    local adapter = config.get_adapter_by_scheme(scheme)
    if not adapter or not path or adapter.name ~= "files" then
        return
    end
    local fullpath = fs.shorten_path(fs.posix_to_os_path(path) .. entry.name)
    open_cmdline_with_args("!mv " .. fullpath .. " " .. fullpath)
end

return M
