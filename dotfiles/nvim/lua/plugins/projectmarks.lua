return {
    'BartSte/nvim-project-marks',
    event = "VeryLazy",
    config = function()
        require('config.projectmarks')
    end,
}
