local map = require("helpers.keymapper")
local M = {}

M.setup = function()
    map.nnoremap("<leader>c=", "vip:!lensort '='")
    map.vnoremap("<leader>c=", ":!lensort '='<CR>")
end

return M
