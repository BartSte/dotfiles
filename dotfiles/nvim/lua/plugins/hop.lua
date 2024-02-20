return {
    'smoka7/hop.nvim',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.hop')
    end
}
