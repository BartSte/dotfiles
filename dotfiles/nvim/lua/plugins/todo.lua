return {
    "folke/todo-comments.nvim",
    event = 'VeryLazy',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = require('config.todo-comments').config
}
