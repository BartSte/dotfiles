lua require('plugins')

cd ~/dotfiles/nvim/vim
so settings.vim
so mappings.vim
so windows.vim
so colors.vim
so keep-centered.vim

so conf-auto_save.vim
so conf-fugitive.vim
so conf-fzf.vim
so conf-markdown.vim
so conf-vim-bbye.vim
so conf-vim-test.vim
so conf-vimspector.vim
cd -

lua require('conf-hop')
lua require('conf-lualine')
lua require('conf-nvim-tree')
lua require('conf-treesitter')
lua require('conf-mason')
lua require('conf-neodev')
lua require('conf-lsp-init')
lua require('conf-lsp-servers')
lua require('conf-lsp-mappings')
lua require('conf-cmp')
lua require('conf-autopairs')
lua require('conf-neogen')
lua require('conf-luasnip')
lua require('conf-orgmode')
lua require('config-lint')
lua require('local-shada')
lua require('global-marks')
lua require('autocmds')
