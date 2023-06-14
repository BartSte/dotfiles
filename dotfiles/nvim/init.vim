lua require('plugins')

cd ~/dotfiles/nvim/vim
so settings.vim
so mappings.vim
so windows.vim
so colors.vim
so keep-centered.vim
so fold.vim

so config-auto_save.vim
so config-fugitive.vim
so config-fzf.vim
so config-markdown.vim
so config-vim-bbye.vim
so config-vim-test.vim
so config-table.vim
so config-peekaboo.vim
cd -

lua require('linux')

lua require('config-hop')
lua require('config-lualine')
lua require('config-treesitter')
lua require('config-neodev')
lua require('config-lsp-init')
lua require('config-lsp-servers')
lua require('config-lsp-mappings')
lua require('config-null-ls')
lua require('config-cmp')
lua require('config-nvim-dap')
lua require('config-nvim-dap-virtual-text')
lua require('config-mason')
lua require('config-autopairs')
lua require('config-neogen')
lua require('config-orgmode')
lua require('config-oil')

lua require('local-shada')
lua require('global-marks')
lua require('autocmds')
