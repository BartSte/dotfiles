return {
    'smoka7/hop.nvim',
    cond = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.hop')
    end
}
