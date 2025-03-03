---@class LuaLine
---@field code_companion table
---@field tabs function
---@field venv function
---@field shada function
---@field marks function
---@field mark_exists function
---@field find_marks function
---@field extract_venv_name function
---@return LuaLine
local M = {}

--- Return the current tab number and the total number of tabs.
---@return string tab_number/total_tabs
M.tabs = function()
  local current_tab = vim.fn.tabpagenr()
  local number_of_tabs = vim.fn.tabpagenr("$")
  return "tab " .. string.format("%d/%d", current_tab, number_of_tabs)
end

--- Extract the virtual environment name from the VIRTUAL_ENV environment.
--
--- If the virtual environment name is in the exclude list, it will be removed
--- from the path and the next directory will be checked.
---@param venv string The virtual environment path
---@param exclude table<string>|nil A list of names to exclude
local function extract_venv_name(venv, exclude)
  exclude = exclude or { "venv", ".venv" }
  venv = string.gsub(venv, "\\", "/")
  local name = string.match(venv, "/([^/]*)$")
  if vim.tbl_contains(exclude, name) then
    local new_venv = string.match(venv, "^(.*)/[^/]*$")
    return extract_venv_name(new_venv, exclude)
  else
    return name
  end
end

--- Return the current virtual environment name with an icon if it exists, and
--- the current file type is python.
---@return string name virtualenv_name
M.venv = function()
  return extract_venv_name(vim.env.VIRTUAL_ENV)
end


M.codecompanion_spinner = require("lualine.component"):extend()
M.codecompanion_spinner.processing = false
M.codecompanion_spinner.spinner_index = 1

local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_symbols_len = 10

--- Initializes a new CodeCompanionSpinner instance
---@param options table Configuration options passed to super constructor
function M.codecompanion_spinner:init(options)
  M.codecompanion_spinner.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      self.model = request.data.adapter.model
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

--- Updates statusline with spinner animation when processing
---@return string|nil Current spinner symbol if processing, nil otherwise
function M.codecompanion_spinner:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return string.format("%s %s", self.model, spinner_symbols[self.spinner_index])
  else
    return nil
  end
end

return M
