local map = require("helpers.keymapper")

-- select the module using this regex: ^import|from ([a-zA-Z0-9]+)
-- run !pyright --create-stub <module> to create a stub file
local function create_stub()
    local re_import = "^import ([a-zA-Z0-9_]+)"
    local re_from = "^from ([a-zA-Z0-9_]+)"
    local line = vim.fn.getline(".")
    local _, _, from = line:find(re_from)
    local _, _, import = line:find(re_import)
    local module = from or import
    if module == nil then
        vim.api.nvim_notify("No module found", vim.log.levels.ERROR, {})
        return
    else
        vim.cmd("!pyright --createstub " .. module)
    end
end

map.buffer_nnoremap('<leader>x', create_stub)

map.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
map.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

map.buffer_nnoremap('gl', ':TestVisit<CR>')

map.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytesttmux<CR>')

map.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytesttmuxdebug<CR>')

require("projectrc").require("after.ftplugin.python").setup()
