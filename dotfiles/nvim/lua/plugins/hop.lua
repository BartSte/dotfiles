return {
    'smoka7/hop.nvim',
    tag = 'v2.5.1',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.hop')
    end
}
