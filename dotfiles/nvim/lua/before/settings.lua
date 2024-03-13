vim.cmd("filetype on")

vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.cedit = "<C-t>"
vim.opt.cmdheight = 1
vim.opt.colorcolumn = ""
vim.opt.colorcolumn = "+1"
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.diffopt:append("vertical", "iblank", "closeoff")
vim.opt.expandtab = true
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.ignorecase = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.pumwidth = 15
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("flmnxoOAI")
vim.opt.showcmd = true
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.spell = false
vim.opt.spelllang = "en,nl"
vim.opt.swapfile = false
vim.opt.textwidth = 0
vim.opt.timeout = false
vim.opt.updatetime = 750
vim.opt.wildmenu = false
vim.opt.wrap = false
vim.opt.writebackup = false

if vim.fn.has("termguicolors") then
    vim.opt.termguicolors = true
end

vim.cmd("let &t_SI = \"\\e[6 q\"")
vim.cmd("let &t_SR = \"\\e[4 q\"")
vim.cmd("let &t_EI = \"\\e[2 q\"")
