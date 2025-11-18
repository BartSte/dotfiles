-- General functions that are too small to be in their own module.

---@class FunctionHelpers
---@field decorate function
---@field tabulate function(header: table, rows: table): string
local M = {}

--- Create a composite function that executes each provided callback in order.
---@param functions table<number, function|nil> Collection of functions to decorate.
---@return function decorated Function that runs every callback with the same arguments.
function M.decorate(functions)
    return function(...)
        for _, func in pairs(functions) do
            if func ~= nil then
                func(...)
            end
        end
    end
end

--- Format a header and rows into an aligned markdown-like table.
---@param header string[] The header of the table.
---@param rows string[][] The rows of the table.
---@return string formatted_table A formatted table string with aligned columns.
function M.tabulate(header, rows)
    local column_widths = {}
    for i, column in ipairs(header) do
        column_widths[i] = #column
    end

    for _, row in ipairs(rows) do
        for i, column in ipairs(row) do
            column_widths[i] = math.max(column_widths[i], #column)
        end
    end

    local result = {}
    result[#result + 1] = "|"
    for i, column in ipairs(header) do
        result[#result + 1] = " " .. column .. string.rep(" ", column_widths[i] - #column) .. " |"
    end

    result[#result + 1] = "\n|"
    for i, width in ipairs(column_widths) do
        result[#result + 1] = string.rep("-", width + 2) .. "|"
    end

    for _, row in ipairs(rows) do
        result[#result + 1] = "\n|"
        for i, column in ipairs(row) do
            result[#result + 1] = " " .. column .. string.rep(" ", column_widths[i] - #column) .. " |"
        end
    end

    return table.concat(result)
end

--- Determine whether a value is considered empty or nil-like.
---@param x any The value to evaluate for emptiness.
---@return boolean is_empty True when the value is nil, blank, or an empty table.
function M.is_empty(x)
    -- nil
    if x == nil then
        return true
    end

    -- empty string or whitespace-only string
    if type(x) == "string" and x:match("^%s*$") then
        return true
    end

    -- empty table
    if type(x) == "table" then
        if vim.tbl_isempty(x) then
            return true
        elseif #x == 1 and M.is_empty(x[1]) then
            return true
        end
        return true
    end

    return false
end

return M
