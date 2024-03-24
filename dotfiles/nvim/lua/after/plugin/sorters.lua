local map = require("helpers.keymapper")

map.nnoremap("<leader>cc", "vip:sort<CR>")
map.vnoremap("<leader>cc", ":sort<CR>")

map.nnoremap("<leader>c=", "vip:!lensort '='<CR>")
map.vnoremap("<leader>c=", ":!lensort '='<CR>")

map.nnoremap("<leader>c:", "vip:!lensort ': '<CR>")
map.vnoremap("<leader>c:", ":!lensort ': '<CR>")
