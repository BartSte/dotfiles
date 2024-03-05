local M = {}

M.setup = function()
    local join = require("helpers.path").join
    local dir_config = vim.fn.stdpath('config')
    local after = join(dir_config, "lua", "after")
    local opts = {
        change_detection = { enabled = false, },
        performance = {
            rtp = {
                paths = { after },
                disabled_plugins = {
                    "gzip",
                    "netrwPlugin",
                    "tarPlugin",
                    "tutor",
                    "zipPlugin",
                }
            }
        },
    }
    require("lazy").setup("plugins", opts)
end

return M
