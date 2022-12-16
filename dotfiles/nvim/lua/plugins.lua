local packer = require('packer')

local function markdown_hook()
    vim.fn["mkdp#util#install"]()
end

local function plugins(use)
    --Package managers
    use 'wbthomason/packer.nvim'
    use "williamboman/mason-lspconfig.nvim"
    use "williamboman/mason.nvim"

    --Looks
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'luisiacc/gruvbox-baby', branch = 'main' }

    --Lsp
    use "folke/neodev.nvim"
    use "rafamadriz/friendly-snippets"
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind.nvim'

    -- Completion
    use "danymat/neogen"
    use 'L3MON4D3/LuaSnip'
    use 'dmitmel/cmp-cmdline-history'
    use 'f3fora/cmp-spell'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'uga-rosa/cmp-dictionary'

    -- Navigation
    use 'BartSte/vim-center-cursor'
    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use 'junegunn/fzf.vim'
    use 'moll/vim-bbye'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use { 'phaazon/hop.nvim', branch = 'v2' }

    -- Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use { "iamcco/markdown-preview.nvim", run = markdown_hook }
    use "windwp/nvim-autopairs"

    -- Source control
    use 'rbong/vim-flog'
    use 'tpope/vim-fugitive'

    -- Testing and debugging
    use 'puremourning/vimspector'
    use 'vim-test/vim-test'
    use 'ThePrimeagen/harpoon'

    -- Org
    use 'nvim-orgmode/orgmode'
    use 'akinsho/org-bullets.nvim'
    use 'dhruvasagar/vim-table-mode'
    use 'lukas-reineke/headlines.nvim'

    -- External
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }
end

return packer.startup(plugins)
