return {
    'BartSte/hop.nvim',
    -- 'smoka/hop.nvim', -- maintained fork of original
    -- It is not compatible yet as they changed module that containts the
    -- `regex_by_search` function that I uced in the helpers.
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('config.hop')
    end
}
