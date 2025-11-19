return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function() require("config.markdown_preview") end,
    dependencies = {
        'dhruvasagar/vim-table-mode',
    }
}
