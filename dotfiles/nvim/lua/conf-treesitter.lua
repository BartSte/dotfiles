require 'nvim-treesitter.install'.compilers = { "cl", "gcc", "clang" }

---@diagnostic disable-next-line: unused-local
local function disable_highlight(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
        return true
    end
end

local my_highlight = {
    enable = true,
    disable = disable_highlight,
    additional_vim_regex_highlighting = false,
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "markdown", "bash", "vim", "lua", "cpp", "python", "json", "help" , "cpp", "toml", "latex"},

    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = my_highlight,
    indent = { enable = true },
}
