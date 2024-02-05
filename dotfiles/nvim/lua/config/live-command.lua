local M = {}

local commands = {
    Norm = { cmd = "norm" },
}

M.setup = function()
    require("live-command").setup({
        commands = commands,
    })
end

return M
