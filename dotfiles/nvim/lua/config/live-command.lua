local M = {}

-- This will transform ":5Reg a" into ":norm 5@a"
local function reg_args(opts)
    return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
end

local commands = {
    Norm = { cmd = "norm" },
    Reg = { cmd = "norm", args = reg_args, range = "" },
}

M.setup = function()
    require("live-command").setup({
        commands = commands,
    })
end

return M
