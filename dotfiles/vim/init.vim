set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

luafile ~/dotfiles/vim/hop.lua
luafile ~/dotfiles/vim/nvim-tree.lua
luafile ~/dotfiles/vim/lualine.lua
luafile ~/dotfiles/vim/treesitter.lua

set formatoptions-=tc
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

