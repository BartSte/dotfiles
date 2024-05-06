return {
    'BartSte/nvim-project-marks',
    lazy = false,
    config = function()
        require('config.projectmarks')
    end,
    dir = '$HOME/code/nvim-project-marks'
}
