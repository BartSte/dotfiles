local packer = require('packer')

local function markdown_hook()
    vim.fn["mkdp#util#install"]()
end

local function plugins(use)
    --Package managers
    use 'wbthomason/packer.nvim'
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "jay-babu/mason-null-ls.nvim"

    --Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'

    --Looks
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use { 'luisiacc/gruvbox-baby', branch = 'main' }
    use { 'alvarosevilla95/luatab.nvim',
        requires = 'kyazdani42/nvim-web-devicons' }

    --Lsp
    use "folke/neodev.nvim"
    use "rafamadriz/friendly-snippets"
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'

    --Completion
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

    --Navigation
    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use 'junegunn/fzf.vim'
    use 'moll/vim-bbye'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use { 'aznhe21/hop.nvim', branch = 'fix-some-bugs' }
    -- use 'phaazon/hop.nvim' -- was unstable

    --Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use "windwp/nvim-autopairs"
    use "jbyuki/venn.nvim"

    --Source control
    use 'tpope/vim-fugitive'

    --Testing and debugging
    use 'puremourning/vimspector'
    use 'vim-test/vim-test'
    use 'ThePrimeagen/harpoon'

    --Org
    use 'nvim-orgmode/orgmode'
    use 'akinsho/org-bullets.nvim'
    use 'dhruvasagar/vim-table-mode'

    --Markdown
    use { "iamcco/markdown-preview.nvim", run = markdown_hook }

    --Drawing
    use 'willchao612/vim-diagon'

end

return packer.startup(plugins)
