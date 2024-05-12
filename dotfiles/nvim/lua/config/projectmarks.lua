-- Get the name of the current working directory.
local function cwd_name()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

require('projectmarks').setup({
    shadafile = "~/.local/state/nvim/shada/" .. cwd_name() .. ".shada",
    abbreviations = true,
})
