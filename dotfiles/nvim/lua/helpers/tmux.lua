local M = {}

local function run(args)
    local command = { 'tmux' }
    vim.list_extend(command, args)
    local result = vim.system(command, { text = true }):wait()
    if result.code ~= 0 then
        error(vim.trim(result.stderr or '') ~= '' and vim.trim(result.stderr)
            or 'tmux command failed')
    end
    return vim.trim(result.stdout or '')
end

--- Send a shell command to window 1, pane 0 in the current tmux session.
--- Interrupt the current command before sending literal text and Enter.
---@param command string
---@return boolean success
function M.send_command(command)
    local ok, err = pcall(function()
        if vim.fn.executable('tmux') ~= 1 then
            error('tmux is not installed')
        end
        local source = vim.env.TMUX_PANE
        if not source or source == '' then
            error('Neovim must run inside tmux')
        end

        local session = run({ 'display-message', '-p', '-t', source, '#{session_id}' })
        local target = run({ 'display-message', '-p', '-t', session .. ':1.0', '#{pane_id}' })
        if target == source then
            error('The tmux destination is the Neovim pane')
        end

        run({ 'send-keys', '-t', target, 'C-c' })
        run({ 'send-keys', '-t', target, '-l', '--', command })
        run({ 'send-keys', '-t', target, 'Enter' })
    end)
    if not ok then
        vim.notify('Cannot send command to tmux: ' .. tostring(err), vim.log.levels.ERROR)
    end
    return ok
end

return M
