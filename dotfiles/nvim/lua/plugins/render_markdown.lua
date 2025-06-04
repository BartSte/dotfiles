return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" },
    config = function()
        require("config.render_markdown")
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
