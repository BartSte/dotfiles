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
    use { "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim"} }

    --Lsp
    use "folke/neodev.nvim"
    use "rafamadriz/friendly-snippets"
    use 'neovim/nvim-lspconfig'
    use 'jose-elias-alvarez/null-ls.nvim'

    --Completion
    use "danymat/neogen"
    use 'L3MON4D3/LuaSnip'
    use 'dmitmel/cmp-cmdline-history'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rcarriga/cmp-dap'

    --Navigation
    use { 'junegunn/fzf.vim', requires = { 'junegunn/fzf', run = ':call fzf#install()' } }
    use {'junegunn/vim-peekaboo'}
    use 'moll/vim-bbye'
    use 'stevearc/oil.nvim'
    use { 'aznhe21/hop.nvim', branch = 'fix-some-bugs' }
    -- use 'phaazon/hop.nvim' -- was unstable

    --Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-obsession'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-scriptease'

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
    use 'akinsho/org-bullets.nvim'
    use 'dhruvasagar/vim-table-mode'

    --Markdown
    use { "iamcco/markdown-preview.nvim", run = markdown_hook }

    --Drawing
    use 'willchao612/vim-diagon'
end

return packer.startup(plugins)
