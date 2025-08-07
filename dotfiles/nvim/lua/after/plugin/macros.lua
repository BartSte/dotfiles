-- Containing all neovim macros that is use

-- Deletes the type hint for python variable
vim.fn.setreg('t', 'f:dt=i ^')
vim.fn.setreg('l', ":s/\\\\/\\//g")

