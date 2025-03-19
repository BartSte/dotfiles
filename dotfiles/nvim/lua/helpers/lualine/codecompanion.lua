local M = {}

M.spinner = require("lualine.component"):extend()
M.spinner.processing = false
M.spinner.spinner_index = 1

local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_symbols_len = 10

--- Initializes a new CodeCompanionSpinner instance
---@param options table Configuration options passed to super constructor
function M.spinner:init(options)
    M.spinner.super.init(self, options)

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
function M.spinner:update_status()
    if self.processing then
        self_index = (self.spinner_index % spinner_symbols_len) + 1
        return string.format("%s %s", self.model, spinner_symbols[self_index])
    else
        return nil
    end
end

return M
