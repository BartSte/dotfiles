return {
    'junegunn/fzf.vim',
    keys = {
        { '<a-o>' },
        { '<a-v>' },
        { '<a-V' },
        { '<a-r>' },
        { '<a-c>' },
        { '<a-h>' },
        { '<a-H>' },
        { '<a-a>' },
        { '<a-b>' },
        { '<a-B>' },
    },
    cmd = { 'Ag' },
    config = function()
        vim.cmd('runtime vim/config/fzf.vim')
    end,
    dependencies = {
        { 'junegunn/fzf', build = ':call fzf#install()' },
    }
}

-- return {
--   "ibhagwan/fzf-lua",
--   dependencies = { "nvim-tree/nvim-web-devicons" },
--   config = function()
--     -- calling `setup` is optional for customization
--     require("config.fzf").setup()
--   end
-- }
