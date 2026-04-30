local M = {}

---Find the lua/after directory in the current configuration.
---@return string lua_after The path to the lua/after directory.
local function find_lua_after()
    local path = require("helpers.path")
    local lua_after = path.join(path.config_dir(), "lua", "after")
    if vim.fn.isdirectory(lua_after) then
        return lua_after
    end
    error("Could not find lua/after directory.")
end

---Find the dotfiles repo checkout that contains extra runtime files like queries.
---@return string|nil dotfiles_nvim The path to the dotfiles checkout when present.
local function find_dotfiles_nvim()
    local path = require("helpers.path")
    local dotfiles_nvim = path.join(path.home(), "dotfiles", "nvim")
    if vim.fn.isdirectory(path.join(dotfiles_nvim, "queries")) == 1 then
        return dotfiles_nvim
    end
    return nil
end

---Setup the lazy loading of plugins.
M.setup = function()
    local lua_after = find_lua_after()
    local rtp_paths = { lua_after }
    local dotfiles_nvim = find_dotfiles_nvim()
    if dotfiles_nvim ~= nil then
        table.insert(rtp_paths, dotfiles_nvim)
    end
    local opts = {
        change_detection = { enabled = false, notify = false },
        performance = {
            rtp = {
                paths = rtp_paths,
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
