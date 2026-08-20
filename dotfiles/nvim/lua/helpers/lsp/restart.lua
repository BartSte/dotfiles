local ID = "lsp_restart"

local function restart()
    vim.cmd("lsp restart")
    vim.notify("LSP restarted", vim.log.levels.INFO, { title = "LSP", id = ID })
end

return restart
