return {
    'smoka7/hop.nvim',
    event = { "BufReadPost", "BufNewFile" },
    cond = function()
        return false
    end,
    config = function()
        require('config.hop')
    end
}
