-- General functions that are too small to be in their own module.

---@class FunctionHelpers
---@field decorate function
---@field tabulate function(header: table, rows: table): string
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

--- Create a table from a header and rows.
---@param header string[] The header of the table
---@param rows string[][] The rows of the table
---@return string table A table in string format. The table columns are
--- aligned. For example:
-- | Header 1 | Header 2 | Header 3 |
-- |    x     |    y     |    z     |
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

return M
