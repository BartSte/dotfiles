local packer = require('packer')

local markdown_hook = function()
    vim.fn["mkdp#util#install"]()
end

local plugins = function(use)
    --Packer manages itself
    use 'wbthomason/packer.nvim'

    --Looks
    use 'sainnhe/gruvbox-material'
    use 'frazrepo/vim-rainbow'
    use 'machakann/vim-highlightedyank'
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'vim-python/python-syntax'

    --Lsp
    use {'neoclide/coc.nvim', branch = 'release'}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Navigation
    use {'junegunn/fzf', run = ":call fzf#install()" }
    use 'junegunn/fzf.vim'
    use 'phaazon/hop.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use 'moll/vim-bbye'

    -- Editing
    use '907th/vim-auto-save'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use {"iamcco/markdown-preview.nvim", run = markdown_hook}
    use 'chrisbra/csv.vim'

    -- Source control
    use 'junegunn/gv.vim'
    use 'tpope/vim-fugitive'

    -- Testing and debugging
    use 'puremourning/vimspector'
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
    use 'vim-test/vim-test'
end

return packer.startup(plugins)
