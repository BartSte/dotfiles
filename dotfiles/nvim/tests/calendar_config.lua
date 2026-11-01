local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h')
local configured, plugin_options, selected
package.loaded.orgmode = { setup = function(opts) configured = opts end }
local scratch = vim.fn.tempname()
package.loaded['helpers.path'] = {
    home = function() return scratch end,
    join = function(...) return table.concat({...}, '/') end,
}
vim.env.XDG_DATA_HOME = scratch
package.loaded.khalorg = {
    setup = function(opts) plugin_options = opts end,
    new = function(opts) selected = opts end,
    edit = function(opts) selected = opts end,
    edit_all = function(opts) selected = opts end,
    list = function(opts) selected = opts end,
}
dofile(root .. '/lua/config/orgmode.lua')
assert(plugin_options.executable == 'khalorg-local')
assert(not configured.org_custom_exports.d and not configured.org_custom_exports.s)
for _, key in ipairs({'e', 'w'}) do
    local capture = configured.org_capture_templates[key]
    assert(capture.target:find('/khalorg/inbox/', 1, true))
    assert(not capture.target:find('dropbox', 1, true))
end
vim.cmd('edit ' .. scratch .. '/khalorg/inbox/outlook_work.org')
configured.org_custom_exports.n.action()
assert(selected.calendar == 'outlook_work', 'Work captures must not use the personal calendar')
vim.cmd('edit ' .. scratch .. '/khalorg/agendas/outlook_personal.org')
assert(vim.bo.readonly, 'Generated agendas must resist accidental writes')
configured.org_custom_exports.e.action()
assert(selected.calendar == 'outlook_personal')
local called
vim.system = function(argv, _, callback)
    called = argv
    callback({code = 1, stderr = 'Synthetic network failure'})
end
selected.on_complete({code = 0})
assert(called[1] == 'mycalsync' and called[2] == '--verbose', 'Edits must refresh through the local stack')
vim.wait(30)
vim.fn.delete(scratch, 'rf')
print('PASS: local plugin routing, capture isolation, generated files, and refresh callback')
