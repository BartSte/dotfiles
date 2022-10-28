luafile ~/dotfiles/vim/plugins.lua

source ~/dotfiles/vim/functions.vim
source ~/dotfiles/vim/constants.vim
source ~/dotfiles/vim/mappings.vim
source ~/dotfiles/vim/settings.vim
source ~/dotfiles/vim/linux.vim
source ~/dotfiles/vim/windows.vim

source ~/dotfiles/vim/markdown.vim
source ~/dotfiles/vim/coc.vim

luafile ~/dotfiles/vim/hop.lua
luafile ~/dotfiles/vim/nvim-tree.lua
luafile ~/dotfiles/vim/lualine.lua
luafile ~/dotfiles/vim/treesitter.lua

source ~/dotfiles/vim/colors.vim

set formatoptions-=tc
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
