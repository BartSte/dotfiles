local dap = require('dap')
local os_path = require('os_path')
local widgets = require('dap.ui.widgets')
local keymapper = require('keymapper')
local dap_python = require('dap-python')
local virtual_text = require("nvim-dap-virtual-text")

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'

local function get_debugpy()
    local base = os_path.path_join(vim.fn.stdpath('data'), 'mason', 'packages', 'debugpy', 'venv')
    if vim.fn.has("win32") == 1 then
        -- return os_path.path_join(base, 'Scripts', 'python')
        return vim.g.python3_host_prog
    else
        return os_path.path_join(base, 'bin', 'python')
    end
end

dap_python.setup(get_debugpy())
dap_python.test_runner = 'pytest'

local test_runners = dap_python.test_runners
local centered_float_frames = function() widgets.centered_float(widgets.frames) end
local centered_float_scopes = function() widgets.centered_float(widgets.scopes) end

vim.keymap.set('n', '<F4>', dap.run_last)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<a-R>', dap.repl.open)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', widgets.hover)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', widgets.preview)
vim.keymap.set('n', '<Leader>df', centered_float_frames)
vim.keymap.set('n', '<Leader>ds', centered_float_scopes)

keymapper.nnoremap('<a-C>', ':lua require("dap-python").test_class()<CR>')
keymapper.nnoremap('<a-T>', ':lua require("dap-python").test_method()<CR>')
keymapper.vnoremap('<a-T>', ':lua require("dap-python").test_selection()<CR>')


vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

virtual_text.setup {
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
    all_references = false, -- show virtual text on all all references of the variable (not only definitions)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param _buf number
    --- @param _stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param _node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, _buf, _stackframe, _node)
        return variable.name .. ' = ' .. variable.value
    end,

    -- experimental features:
    virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}
