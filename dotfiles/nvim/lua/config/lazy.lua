local M = {}

---Find the lua/after directory in the current configuration.
---@return string lua_after The path to the lua/after directory.
local function find_lua_after()
    local dir_configs = require("helpers.path").config_dir()
    for _, dir_config in ipairs(dir_configs) do
        local lua_after = require("helpers.path").join(dir_config, "lua", "after")
        if vim.fn.isdirectory(lua_after) then
            return lua_after
        end
    end
    error("Could not find lua/after directory.")
end

---Setup the lazy loading of plugins.
M.setup = function()
    local lua_after = find_lua_after()
    local opts = {
        change_detection = { enabled = false, notify = false },
        performance = {
            rtp = {
                paths = { lua_after },
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
