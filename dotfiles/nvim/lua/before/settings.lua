vim.cmd("filetype on")
vim.cmd("syntax on")

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.autoindent = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = ""
vim.opt.colorcolumn = "+1"
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.diffopt:append("vertical", "iblank", "closeoff")
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.pumwidth = 15
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("flmnxoOAI")
vim.opt.showcmd = true
vim.opt.showmode = false
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
vim.ui.open = require("helpers.platform").open
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
vim.wo.foldtext = "v:lua.FoldText()"
vim.wo.foldlevel = 99

if vim.fn.has("termguicolors") then
    vim.opt.termguicolors = true
end

vim.cmd("set fillchars=fold:\\ ")
vim.cmd("let &t_SI = \"\\e[6 q\"")
vim.cmd("let &t_SR = \"\\e[4 q\"")
vim.cmd("let &t_EI = \"\\e[2 q\"")
