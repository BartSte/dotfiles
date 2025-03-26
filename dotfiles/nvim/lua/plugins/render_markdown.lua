return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown", "codecompanion" },
    config = function()
        require("config.render_markdown")
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
