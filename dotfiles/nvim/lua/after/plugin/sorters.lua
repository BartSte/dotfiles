local map = require("helpers.keymapper")
local M = {}

M.setup = function()
    map.nnoremap("<leader>ce", "vip:!lensort '='<CR>")
    map.vnoremap("<leader>ce", ":!lensort '='<CR>")

    map.nnoremap("<leader>c:", "vip:!lensort ': '<CR>")
    map.vnoremap("<leader>c:", ":!lensort ': '<CR>")
end

return M
