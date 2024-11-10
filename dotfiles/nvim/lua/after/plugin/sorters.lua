local map = require("helpers.keymapper")


-- TODO: read abount the `:map-operator` help page to implement an operator
-- pending sorter.`
--
-- function _G.CmdOperator(type)
--     if type == 'line' then
--         vim.cmd('normal! `[V`]')
--         vim.cmd("'[,']" .. cmd)
--     elseif type == 'char' then
--         vim.cmd('normal! `[v`]')
--         vim.cmd("'[,']" .. cmd)
--     else
--         vim.notify("Blockwise sort not supported", vim.log.levels.ERROR)
--     end
-- end
-- map.nnoremap("<leader>cc", ":<C-u>set opfunc=v:lua.SortOperator<CR>g@")

map.nnoremap("<leader>c,", "vip:!lensort ','<CR>")
map.vnoremap("<leader>cc", ":sort<CR>")

map.nnoremap("<leader>c=", "vip:!lensort '='<CR>")
map.vnoremap("<leader>c=", ":!lensort '='<CR>")

map.nnoremap("<leader>c:", "vip:!lensort ': '<CR>")
map.vnoremap("<leader>c:", ":!lensort ': '<CR>")
