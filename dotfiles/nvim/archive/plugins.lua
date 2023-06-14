local packer = require('packer')

local function markdown_hook()
    vim.fn["mkdp#util#install"]()
end

local function plugins(use)
    --Helpers
    use 'nvim-lua/plenary.nvim'

    --Package managers
    use 'wbthomason/packer.nvim'
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "jay-babu/mason-null-ls.nvim"

    --Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-context'

    --Looks
    use 'nvim-lualine/lualine.nvim'
    use { 'luisiacc/gruvbox-baby', branch = 'main' }

    --Lsp
    use "folke/neodev.nvim"
    use 'neovim/nvim-lspconfig'
    use 'jose-elias-alvarez/null-ls.nvim'

    --Completion
    use "danymat/neogen"
    use 'dmitmel/cmp-cmdline-history'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'rcarriga/cmp-dap'
    use {
        'zbirenbaum/copilot.lua',
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("config-copilot")
        end,
    }

    --Navigation
    use { 'junegunn/fzf.vim', requires = { 'junegunn/fzf', run = ':call fzf#install()' } }
    use { 'junegunn/vim-peekaboo' }
    use 'moll/vim-bbye'
    use 'stevearc/oil.nvim'
    use 'BartSte/hop.nvim'

    --Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-obsession'
    use 'tpope/vim-scriptease'
    use 'windwp/nvim-autopairs'

    --Source control
    use 'tpope/vim-fugitive'
    use 'junegunn/gv.vim'

    --Testing
    use 'vim-test/vim-test'
    use 'jgdavey/tslime.vim'

    --Debugging
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-dap-python'
    use 'jay-babu/mason-nvim-dap.nvim'
    use 'theHamsta/nvim-dap-virtual-text'

    --Org
    use 'nvim-orgmode/orgmode'
    use 'BartSte/nvim-khalorg'
    use 'dhruvasagar/vim-table-mode'

    --Markdown
    use { "iamcco/markdown-preview.nvim", run = markdown_hook }
end

return packer.startup(plugins)
