local packer = require('packer')

local function markdown_hook()
    vim.fn["mkdp#util#install"]()
end

local function plugins(use)
    --Packer manages itself
    use 'wbthomason/packer.nvim'

    --Looks
    use 'sainnhe/gruvbox-material'
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'

    --Lsp
    use "danymat/neogen"
    use "folke/neodev.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "williamboman/mason.nvim"
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'neovim/nvim-lspconfig'
    use 'saadparwaiz1/cmp_luasnip'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Navigation
    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use 'junegunn/fzf.vim'
    use { 'phaazon/hop.nvim', branch = 'v2' }
    use 'nvim-tree/nvim-tree.lua'
    use 'moll/vim-bbye'
    use 'nvim-lua/plenary.nvim'

    -- Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use { "iamcco/markdown-preview.nvim", run = markdown_hook }
    use 'chrisbra/csv.vim'
    use "windwp/nvim-autopairs"

    -- Source control
    use 'junegunn/gv.vim'
    use 'tpope/vim-fugitive'

    -- Testing and debugging
    use 'puremourning/vimspector'
    use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
    use 'vim-test/vim-test'
end

return packer.startup(plugins)
