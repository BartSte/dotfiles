luafile ~/dotfiles/vim/lua/plugins.lua
luafile ~/dotfiles/vim/lua/functions.lua

source ~/dotfiles/vim/vim/functions.vim
source ~/dotfiles/vim/vim/constants.vim
source ~/dotfiles/vim/vim/mappings.vim
source ~/dotfiles/vim/vim/settings.vim
source ~/dotfiles/vim/vim/linux.vim
source ~/dotfiles/vim/vim/windows.vim
source ~/dotfiles/vim/vim/colors.vim

noremap <silent><a-X> :NvimTreeFindFile<CR>
noremap <silent><a-x> :NvimTreeToggle<CR>
