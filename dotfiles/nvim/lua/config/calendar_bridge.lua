-- Explicit requests to the Pi. Shared calendar files are read-only projections.
local M = {}
local options, busy = {}, false

local function notify(text, level)
  vim.notify(text, level or vim.log.levels.INFO)
end

local function normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
end

local function state_dir()
  return options.state_dir
end

local function save(path, content)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p', 448)
  local temporary = path .. '.tmp.' .. vim.uv.hrtime()
  vim.fn.writefile(vim.split(content, '\n', {plain=true}), temporary)
  vim.fn.setfperm(temporary, 'rw-------')
  assert(vim.uv.fs_rename(temporary, path), 'Cannot save the pending calendar request')
end

local function uuid()
  return vim.fn.readfile('/proc/sys/kernel/random/uuid')[1]
end

local function selected()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local first = vim.api.nvim_win_get_cursor(0)[1]
  while first > 0 and not lines[first]:match('^%*+ ') do first = first - 1 end
  if first == 0 then error('Select one calendar event heading') end
  local last = first + 1
  while last <= #lines and not lines[last]:match('^%*+ ') do last = last + 1 end
  local item = {}
  for i=first,last-1 do item[#item+1] = lines[i] end
  return table.concat(item, '\n'), first, last-1
end

local function property(text, name)
  return text:match('\n[ \t]*:' .. name .. ':[ \t]*([^\n]*)')
end

local function set_property(text, name, value)
  local pattern = '(\n[ \t]*:' .. name .. ':)[^\n]*'
  if text:find(pattern) then
    return (text:gsub(pattern, function(prefix) return prefix .. ' ' .. value end, 1))
  end
  if not text:find(':PROPERTIES:', 1, true) or not text:find(':END:', 1, true) then
    error('The event needs a complete property drawer')
  end
  return (text:gsub('(\n[ \t]*:END:)', function(ending) return '\n  :' .. name .. ': ' .. value .. ending end, 1))
end

local function is_projection(bufnr)
  local file = normalize(vim.api.nvim_buf_get_name(bufnr))
  for _, path in pairs(options.calendars) do
    if file == normalize(path) then return true end
  end
  return false
end

local function protect(bufnr)
  if not is_projection(bufnr) then return end
  if vim.bo[bufnr].modified then
    local recovery = state_dir() .. '/drafts/recovered-' .. uuid() .. '.org'
    save(recovery, table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'))
    notify('Existing calendar edits were saved as a local recovery draft: ' .. recovery)
  end
  vim.bo[bufnr].readonly = true
  vim.bo[bufnr].modifiable = false
end

function M.draft()
  local text = selected()
  -- A new draft is a new explicit attempt. Old pending requests remain intact.
  text = text:gsub('\n[ \t]*:BRIDGE_REQUEST:[^\n]*', '')
  local path = state_dir() .. '/drafts/' .. uuid() .. '.org'
  save(path, text)
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.bo.readonly = false
  vim.bo.modifiable = true
  vim.bo.filetype = 'org'
  notify('Edit this local draft. Save it, then use CalendarApply. Dropbox cannot overwrite it.')
end

local function valid_request_id(id)
  if type(id) ~= 'string' then return false end
  local a, b, c, d, e = id:match('^([0-9a-f]+)%-([0-9a-f]+)%-([0-9a-f]+)%-([0-9a-f]+)%-([0-9a-f]+)$')
  return a ~= nil and #a == 8 and #b == 4 and #c == 4 and #d == 4 and #e == 12
end

local function send(request, context)
  if type(request) ~= 'table' or not valid_request_id(request.request_id) then
    return notify('Use a pending request UUID', vim.log.levels.ERROR)
  end
  if busy then return notify('Another calendar request is running', vim.log.levels.ERROR) end
  local path = state_dir() .. '/pending/' .. request.request_id .. '.json'
  local encoded = vim.json.encode(request)
  if vim.fn.filereadable(path) == 1 then
    local old = table.concat(vim.fn.readfile(path), '\n')
    if not vim.deep_equal(vim.json.decode(old), request) then
      return notify('This request already has different pending text. Use CalendarDraft for a new attempt.', vim.log.levels.ERROR)
    end
    encoded = old
  else
    save(path, encoded)
  end
  busy = true
  local command = {'ssh', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', options.host, 'dotfiles-linux/bin/calendar-submit'}
  local ok, err = pcall(vim.system, command, {stdin=encoded, text=true, timeout=240000}, function(result)
    vim.schedule(function()
      busy = false
      if result.code ~= 0 then
        local reason = (result.stderr or ''):sub(-2000):gsub('%s+$', '')
        notify('Calendar request is pending. ' .. reason .. '\nThe draft and request are saved. Use CalendarRetry ' .. request.request_id, vim.log.levels.WARN)
        return
      end
      local decoded, response = pcall(vim.json.decode, result.stdout or '')
      if not decoded or response.status ~= 'confirmed' or response.request_id ~= request.request_id or response.calendar ~= request.calendar
          or type(response.uid) ~= 'string' or type(response.baseline) ~= 'string' or not response.baseline:match('^[0-9a-f]+$') or #response.baseline ~= 64 then
        return notify('Calendar response did not match. The request remains pending.', vim.log.levels.ERROR)
      end
      save(path .. '.result', vim.json.encode(response))
      if context and vim.api.nvim_buf_is_valid(context.bufnr) and vim.api.nvim_buf_get_changedtick(context.bufnr) == context.tick then
        local text = set_property(request.org, 'UID', response.uid)
        text = set_property(text, 'BRIDGE_BASELINE', response.baseline)
        text = text:gsub('\n[ \t]*:BRIDGE_REQUEST:[^\n]*', '')
        vim.api.nvim_buf_set_lines(context.bufnr, context.first-1, context.last, false, vim.split(text, '\n', {plain=true}))
        -- The request and response remain durable even if the user does not save.
        notify('Calendar request confirmed through the Pi. Save the updated local draft.')
      else
        notify('Calendar request confirmed. The source changed or was closed; the saved result contains its UID and baseline.')
      end
    end)
  end)
  if not ok then
    busy = false
    notify('Calendar request could not start. Its pending copy is saved: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.submit(action)
  if is_projection(0) then
    if action == 'edit' then return M.draft() end
    return notify('Create events in a local draft, not a shared calendar projection.', vim.log.levels.ERROR)
  end
  local text, first, last = selected()
  local calendar = property(text, 'CALENDAR')
  if not options.calendars[calendar] then return notify('The draft needs an allowed CALENDAR property', vim.log.levels.ERROR) end
  if action == 'new' and property(text, 'UID') and property(text, 'UID') ~= '' then
    return notify('This event already has a UID. Use CalendarApply to edit it.', vim.log.levels.ERROR)
  end
  local id = property(text, 'BRIDGE_REQUEST')
  if not id or id == '' then
    id = uuid()
    text = set_property(text, 'BRIDGE_REQUEST', id)
    vim.api.nvim_buf_set_lines(0, first-1, last, false, vim.split(text, '\n', {plain=true}))
    last = first + #vim.split(text, '\n', {plain=true}) - 1
  end
  if not valid_request_id(id) then return notify('Use a pending request UUID', vim.log.levels.ERROR) end
  local request = {version=1, action=action, calendar=calendar, request_id=id, org=text}
  local context = {bufnr=vim.api.nvim_get_current_buf(), tick=vim.api.nvim_buf_get_changedtick(0), first=first, last=last}
  send(request, context)
end

function M.retry(id)
  if not valid_request_id(id) then return notify('Use a pending request UUID', vim.log.levels.ERROR) end
  local path = state_dir() .. '/pending/' .. id .. '.json'
  local ok, request = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(path), '\n')) end)
  if not ok then return notify('The pending request was not found', vim.log.levels.ERROR) end
  if type(request) ~= 'table' or not valid_request_id(request.request_id) or request.request_id ~= id then
    return notify('The pending request identifier does not match its filename', vim.log.levels.ERROR)
  end
  send(request)
end

function M.edit() return M.submit('edit') end
function M.new() return M.submit('new') end

function M.setup(opts)
  options = opts or {}
  options.host = options.host or vim.env.CALENDAR_BRIDGE_HOST or 'barts@raspberrypi.local'
  assert(options.host:match('^[%w_.@:%-]+$') and options.host:sub(1,1) ~= '-', 'Invalid calendar SSH host')
  options.calendars = options.calendars or {}
  options.state_dir = options.state_dir or (vim.fn.stdpath('state') .. '/calendar-bridge')
  for _, folder in ipairs({'drafts', 'pending'}) do vim.fn.mkdir(state_dir() .. '/' .. folder, 'p', 448) end
  local group = vim.api.nvim_create_augroup('CalendarBridgeProjections', {clear=true})
  vim.api.nvim_create_autocmd({'BufReadPost', 'BufEnter'}, {group=group, callback=function(args) protect(args.buf) end})
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_is_loaded(bufnr) then protect(bufnr) end end
  vim.api.nvim_create_user_command('CalendarDraft', M.draft, {force=true})
  vim.api.nvim_create_user_command('CalendarApply', M.edit, {force=true})
  vim.api.nvim_create_user_command('CalendarNew', M.new, {force=true})
  vim.api.nvim_create_user_command('CalendarRetry', function(args) M.retry(args.args) end, {nargs=1, force=true})
end

return M
