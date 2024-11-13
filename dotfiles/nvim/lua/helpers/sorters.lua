local M = {}

--- Returns a function that sets the `opfunc` option to the provided function
--- and feeds the `g@` key to trigger the sorting. The returned function can be
--- used as a mapping.
--- @param func string The function to use for sorting
--- @return function The function that sets the `opfunc` option and triggers the
--- sorting
local function make_pending_sort(func)
    return function(type)
        vim.opt.opfunc = "v:lua.require'helpers.sorters'." .. func
        vim.api.nvim_feedkeys("g@", "n", true)
    end
end

--- Return the last key pressed
local function last_pressed_key()
    local key = vim.api.nvim_get_vvar("operator")
    if key == "" then
        return nil
    end
    return key
end

M.charsort = {
    func = function() vim.cmd("'[,']sort") end,
    vfunc = function() vim.cmd("'<,'>sort") end,
    ofunc = make_pending_sort("charsort.func"),
}

M.lensort = {
    func = function() vim.cmd("'[,']!lensort =") end,
    vfunc = function() vim.cmd("'<,'>!lensort =") end,
    ofunc = make_pending_sort("lensort.func"),
}

return M
