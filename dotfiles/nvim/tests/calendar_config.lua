local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h')
local configured, bridge_options
package.loaded.orgmode = {setup=function(opts) configured=opts end}
package.loaded['helpers.path'] = {home=function() return '/home/test-user' end, join=function(...) return table.concat({...}, '/') end}
package.loaded['config.calendar_bridge'] = {setup=function(opts) bridge_options=opts end, new=function() end, edit=function() end}
package.loaded.khalorg = {setup=function() error('Local Khalorg writes must not be enabled') end}
dofile(root .. '/lua/config/orgmode.lua')
assert(bridge_options, 'The Pi bridge must be configured')
assert(not configured.org_custom_exports.d, 'No calendar deletion action is permitted')
assert(not configured.org_custom_exports.s, 'No local whole-file sync action is permitted')
assert(configured.org_custom_exports.e.action == package.loaded['config.calendar_bridge'].edit)
for _, key in ipairs({'e','w'}) do
  local capture = configured.org_capture_templates[key]
  assert(capture.target:find('/calendar-bridge/drafts/',1,true), 'Capture must use local drafts')
  assert(capture.template:find(':CALENDAR: outlook_',1,true))
end
print('PASS: calendar configuration disables local writes and captures into local drafts')
