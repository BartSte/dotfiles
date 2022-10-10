set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
luafile ~/dotfiles/vim/hop.lua
luafile ~/dotfiles/vim/nvim-tree.lua
luafile ~/dotfiles/vim/gruvbox.lua
luafile ~/dotfiles/vim/lualine.lua
