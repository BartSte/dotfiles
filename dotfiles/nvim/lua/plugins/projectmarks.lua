return {
    'BartSte/nvim-project-marks',
    lazy = false,
    branch = 'develop',
    config = function()
        require('config.projectmarks')
    end,
}
