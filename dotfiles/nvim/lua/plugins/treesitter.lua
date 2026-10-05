return {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('config.treesitter')
    end,
    build = function()
        local treesitter = require("nvim-treesitter")
        local parsers = require("config.treesitter_parsers")
        treesitter.install(parsers):wait(300000)
        treesitter.update(parsers):wait(300000)
    end,
}
