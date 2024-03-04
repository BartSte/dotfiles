local path = require("helpers.path")

local M = {}

M.bootstrap = function()
    local lazypath = path.join(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

M.setup = function()
    local dir_config = vim.fn.stdpath('config')
    local lua_after = path.join(dir_config, "lua", "after")
    local change_detection = { enabled = false, }
    local rtp = {
        reset = true,
        paths = { lua_after },
        disabled_plugins = {
            "gzip",
            "netrwPlugin",
            "tarPlugin",
            "tutor",
            "zipPlugin",
        }
    }
    local opts = {
        change_detection = change_detection,
        performance = { rtp = rtp },
    }
    M.bootstrap()
    require("lazy").setup("plugins", opts)
end

return M
