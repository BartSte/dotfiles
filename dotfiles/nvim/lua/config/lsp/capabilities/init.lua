---@class Capabilities
---@field ruff fun(client: table): table
local M = {}

local opts = { fallback_value = {} }
local project_specific = require("projectrc").require("config.lsp.capabilities", opts)
vim.list_extend(M, project_specific)

return M
