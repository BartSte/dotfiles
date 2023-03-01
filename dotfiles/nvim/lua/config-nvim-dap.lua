local dap = require('dap')
local widgets = require('dap.ui.widgets')
local keymapper = require('keymapper')
local dap_python = require('dap-python')
local virtual_text = require("nvim-dap-virtual-text")

dap_python.setup('python')
dap_python.test_runner = 'unittest'

vim.keymap.set('n', '<F4>', function() dap.run_last() end)
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)

vim.keymap.set('n', '<a-R>', function() dap.repl.open() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() widgets.hover() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() widgets.preview() end)
vim.keymap.set('n', '<Leader>df', function() widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>ds', function() widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<Leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

keymapper.nnoremap('<a-C>', ':lua require("dap-python").test_class()<CR>')
keymapper.nnoremap('<a-T>', ':lua require("dap-python").test_method()<CR>')
keymapper.vnoremap('<a-T>', ':lua require("dap-python").test_selection()<CR>')

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

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
