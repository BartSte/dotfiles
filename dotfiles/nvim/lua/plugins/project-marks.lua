return {
    'BartSte/nvim-project-marks',
    lazy = false,
    config = function()
        require('projectmarks').setup({})
    end
}
