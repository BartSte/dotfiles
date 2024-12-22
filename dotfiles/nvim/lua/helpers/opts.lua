local M = {}

--- Check if the `opts` table has keys that are not in the `defaults` table. If it
--- does, raise an error.
---@param opts table The options to check.
---@param defaults table The table to check the options against.
M.check_keys = function(opts, defaults)
    for key, _ in pairs(opts) do
        if not defaults[key] then
            error("invalid option: " .. key)
        end
    end
end

--- Raise an error if the `opts` table: has keys that are not in the defaults
--- `opts` table, if it is not a table. If it does not raise an error.
---@param opts table The options to check.
---@return boolean result Whether the options are valid.
M.check_opts = function(opts, defaults)
    if type(opts) ~= "table" then
        error("opts must be a table")
    end
    M.check_keys(opts, defaults)
end

--- Merge the `opts` table with the defaults `opts` table. If the `opts` table has
--- keys that are not in the defaults `opts` table, raise an error. If the `opts`
--- table is not a table, raise an error. `nil` values is allowed in the `opts`
--- table as it will be replaced by the defaults `opts` table.
---@param opts table | nil The options to merge with the defaults `opts` table.
---@param defaults table The defaults `opts` table.
---@return table result The merged options table.
M.merge_opts = function(opts, defaults)
    if opts == nil then
        return defaults
    end
    M.check_opts(opts, defaults)
    return vim.tbl_extend("force", defaults, opts)
end

--- Extend a list with new items without duplicates
---@param list table List to extend
---@param new table New items to add
---@return table Extended list
M.list_extend_no_duplicates = function(list, new)
    for _, item in ipairs(new) do
        if not vim.tbl_contains(list, item) then
            table.insert(list, item)
        end
    end
    return list
end

return M
