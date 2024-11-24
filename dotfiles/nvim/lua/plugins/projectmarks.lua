return {
    'BartSte/nvim-project-marks',
    branch = "develop",
    lazy = false,
    config = function()
        require('config.projectmarks')
    end,
}
