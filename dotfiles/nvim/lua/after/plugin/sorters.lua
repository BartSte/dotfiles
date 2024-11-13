local opfunc = require("helpers.opfunc")
local map = require("helpers.keymapper")

local function pending_sort(func)
    return function()
        vim.opt.opfunc = "v:lua.require'helpers.opfunc'." .. func
        vim.api.nvim_feedkeys("g@", "n", true)
    end
end

local function lensort(arg)
    opfunc.lensort.arg = arg
    return pending_sort("lensort.func")
end


map.nnoremap("<leader>cc", pending_sort("charsort"))
map.vnoremap("<leader>cc", require("helpers.opfunc").charsort)

map.nnoremap("<leader>c=", lensort("="))
-- TODO vnoremap
