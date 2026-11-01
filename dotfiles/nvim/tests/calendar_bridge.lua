-- Run: nvim --headless -u NONE -l dotfiles/nvim/tests/calendar_bridge.lua
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h')
package.path = root .. '/lua/?.lua;' .. package.path
local bridge = require('config.calendar_bridge')
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, 'p')
local projection = tmp .. '/outlook_personal.org'
local original = {'* Original', '<2028-01-03 Mon 11:00-12:00>', ':PROPERTIES:', ':UID: synthetic', ':CALENDAR: outlook_personal', ':BRIDGE_BASELINE: ' .. string.rep('a', 64), ':END:', 'Notes'}
vim.fn.writefile(original, projection)
bridge.setup({state_dir=tmp .. '/state', host='synthetic.invalid', calendars={outlook_personal=projection}})
vim.cmd.edit(vim.fn.fnameescape(projection))
assert(not vim.bo.modifiable, 'Projections must be read-only')
bridge.draft()
assert(vim.bo.modifiable, 'Drafts must be editable')
assert(vim.api.nvim_buf_get_name(0):find('/state/drafts/', 1, true), 'Drafts must be outside Dropbox')
assert(vim.deep_equal(original, vim.fn.readfile(projection)))
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
lines[1] = '* Literal $(touch BAD) `id` $HOME'
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
local calls = {}
local real_system = vim.system
vim.system = function(argv, opts, callback)
  calls[#calls+1] = {argv=argv, input=opts.stdin}
  callback({code=255, stdout='', stderr='offline'})
  return {kill=function() end}
end
bridge.submit('edit')
vim.wait(20)
assert(calls[1].argv[1] == 'ssh')
assert(calls[1].argv[#calls[1].argv] == 'dotfiles-linux/bin/calendar-submit')
local request = vim.json.decode(calls[1].input)
assert(request.org:find('$(touch BAD)', 1, true), 'Text must travel over stdin')
local pending = tmp .. '/state/pending/' .. request.request_id .. '.json'
assert(vim.fn.filereadable(pending) == 1, 'Offline requests must remain recoverable')
assert(vim.deep_equal(original, vim.fn.readfile(projection)), 'Submission must not modify a projection')
bridge.retry(request.request_id)
vim.wait(20)
assert(calls[1].input == calls[2].input, 'Retries must use the identical request')
assert(vim.fn.filereadable(tmp .. '/BAD') == 0)
local before = vim.api.nvim_buf_get_lines(0, 0, -1, false)
vim.system = function(_, opts, callback)
  local req = vim.json.decode(opts.stdin)
  callback({code=0, stdout=vim.json.encode({status='confirmed', calendar=req.calendar, request_id=req.request_id, uid='synthetic', baseline=string.rep('b',64)}), stderr=''})
  return {kill=function() end}
end
bridge.retry(request.request_id)
vim.wait(100, function() return vim.fn.filereadable(pending .. '.result') == 1 end)
assert(vim.fn.filereadable(pending .. '.result') == 1, 'Confirmed results must be durable')
-- A forged or mismatched server result must never clear the pending state.
local result_before = vim.fn.readfile(pending .. '.result')
vim.system = function(_, opts, callback)
  callback({code=0, stdout=vim.json.encode({status='confirmed', request_id='wrong', calendar='outlook_work'}), stderr=''})
  return {kill=function() end}
end
bridge.retry(request.request_id)
vim.wait(50)
assert(vim.deep_equal(result_before, vim.fn.readfile(pending .. '.result')))
vim.cmd.enew({bang=true})
vim.api.nvim_buf_set_lines(0,0,-1,false,{'* New event','<2028-01-03 Mon 13:00-14:00>',':PROPERTIES:',':UID:',':CALENDAR: outlook_personal',':LOCATION:',':END:'})
local new_calls = 0
vim.system = function(_, opts, callback)
  new_calls = new_calls + 1
  local req = vim.json.decode(opts.stdin)
  callback({code=0, stdout=vim.json.encode({status='confirmed', calendar=req.calendar, request_id=req.request_id, uid='new-synthetic', baseline=string.rep('c',64)}), stderr=''})
  return {kill=function() end}
end
bridge.submit('new')
vim.wait(20)
assert(new_calls == 1, 'Blank UID properties must allow explicit creation')
local created = table.concat(vim.api.nvim_buf_get_lines(0,0,-1,false),'\n')
assert(created:find(':UID: new%-synthetic'))
assert(not created:find(':BRIDGE_REQUEST:',1,true), 'Confirmed requests must clear the draft request identifier')
-- Draft request identifiers must never become arbitrary filesystem paths.
local rejected_calls = 0
vim.system = function()
  rejected_calls = rejected_calls + 1
  error('Invalid requests must not invoke SSH')
end
for _, id in ipairs({'../../escaped', string.rep('a', 36), 'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA', 'aaaaaaaaaaaa-aaaa-aaaa-aaaaaaaaaaaa'}) do
  vim.api.nvim_buf_set_lines(0,0,-1,false,{'* Invalid request','<2028-01-03 Mon 13:00-14:00>',':PROPERTIES:',':CALENDAR: outlook_personal',':BRIDGE_REQUEST: ' .. id,':END:'})
  local files_before = vim.fn.glob(tmp .. '/**/*', false, true)
  bridge.submit('new')
  vim.wait(20)
  assert(vim.deep_equal(files_before, vim.fn.glob(tmp .. '/**/*', false, true)), 'Invalid request identifiers must not create files: ' .. id)
  assert(rejected_calls == 0, 'Invalid request identifiers must not invoke SSH')
end
-- Retry must bind the payload identifier to the validated pending filename.
local saved_request = vim.deepcopy(request)
for _, id in ipairs({'../../escaped', string.rep('a', 36), false, '11111111-1111-1111-1111-111111111111'}) do
  saved_request.request_id = id
  vim.fn.writefile({vim.json.encode(saved_request)}, pending)
  local files_before = vim.fn.glob(tmp .. '/**/*', false, true)
  bridge.retry(request.request_id)
  vim.wait(20)
  assert(vim.deep_equal(files_before, vim.fn.glob(tmp .. '/**/*', false, true)), 'Corrupted pending identifiers must not create files')
  assert(rejected_calls == 0, 'Corrupted pending identifiers must not invoke SSH')
end
for _, id in ipairs({'../../escaped', string.rep('a', 36), 'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA', 'aaaaaaaaaaaa-aaaa-aaaa-aaaaaaaaaaaa'}) do
  bridge.retry(id)
  assert(rejected_calls == 0, 'Invalid retry identifiers must not invoke SSH')
end
vim.system = real_system
vim.fn.delete(tmp, 'rf')
print('PASS: read-only projections, local drafts, stdin transport, and durable offline retries')
