lua require('plugins')

cd ~/dotfiles/nvim/vim
so functions.vim
so settings.vim
so mappings.vim
so linux.vim
so windows.vim
so colors.vim

so conf-auto_save.vim
so conf-fugitive.vim
so conf-fzf.vim
so conf-markdown.vim
so conf-vim-bbye.vim
so conf-vim-test.vim
so conf-vimspector.vim
cd -

lua require('conf-hop')
lua require('conf-lsp')
lua require('conf-lualine')
lua require('conf-nvim-tree')
lua require('conf-treesitter')
