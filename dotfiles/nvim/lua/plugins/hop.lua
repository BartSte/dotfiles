return {
    'BartSte/hop.nvim',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.hop')
    end
}
