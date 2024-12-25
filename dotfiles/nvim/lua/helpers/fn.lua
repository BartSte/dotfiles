---@class FunctionHelpers
---@field decorate function
local M = {}


--- Decorate a set of functions to be called in order. They all receive the same
--- arguments.
---@param functions table <function|nil>
---@return function
function M.decorate(functions)
    return function(...)
        for _, func in pairs(functions) do
            if func ~= nil then
                func(...)
            end
        end
    end
end

return M
