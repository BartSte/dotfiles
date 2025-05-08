return {
    'BartSte/nvim-project-marks',
    branch = "develop",
    event = "VeryLazy",
    config = function()
        require('config.projectmarks')
    end,
}
