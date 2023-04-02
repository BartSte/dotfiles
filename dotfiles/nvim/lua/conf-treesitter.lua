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
    additional_vim_regex_highlighting = { 'org' }
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "markdown", "markdown_inline", "bash", "vim", "lua", "cpp", "python",
        "json", "help", "cpp", "toml", "latex", "make", "org", "gitcommit"
    },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = my_highlight,
    indent = { enable = true },
    -- playground = {
    --     enable = true,
    --     disable = {},
    --     updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    --     persist_queries = false, -- Whether the query persists across vim sessions
    --     keybindings = {
    --         toggle_query_editor = 'o',
    --         toggle_hl_groups = 'i',
    --         toggle_injected_languages = 't',
    --         toggle_anonymous_nodes = 'a',
    --         toggle_language_display = 'I',
    --         focus_language = 'f',
    --         unfocus_language = 'F',
    --         update = 'R',
    --         goto_node = '<cr>',
    --         show_help = '?',
    --     },
    -- },
    --Query linter is used for nvim-treesitter-playground if I ever want to use
    --that again.
    -- query_linter = {
    --     disable = {},
    --     enable = true,
    --     lint_events = { "BufWrite", "CursorHold" },
    --     module_path = "nvim-treesitter-playground.query_linter",
    --     use_virtual_text = true
    -- },

}
