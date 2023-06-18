return {
    'jose-elias-alvarez/null-ls.nvim',
    ft = { 'python', 'zsh', 'sh', 'bash', 'markdown' },
    config = function()
        require('config.null-ls')
    end,
    dependencies = {
        "williamboman/mason.nvim",
        {
            "jay-babu/mason-null-ls.nvim",
            config = function()
                require('mason-null-ls').setup({ automatic_installation = false })
            end
        },
    }
}