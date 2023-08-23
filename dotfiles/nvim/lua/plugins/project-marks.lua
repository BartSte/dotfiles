return {
    'BartSte/nvim-project-marks',
    event = 'VeryLazy',
    config = function()
        require('projectmarks').setup({})
    end
}
