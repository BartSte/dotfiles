vim.cmd("filetype on")
vim.cmd("syntax on")

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.autoindent = true
vim.opt.cmdheight = 0
vim.opt.colorcolumn = ""
vim.opt.colorcolumn = "+1"
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
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
local path = require("helpers.path")
vim.ui.open = require("helpers.platform").open

local dotfiles_nvim = path.join(path.home(), "dotfiles", "nvim")
if vim.fn.isdirectory(path.join(dotfiles_nvim, "queries")) == 1 then
    vim.opt.runtimepath:append(dotfiles_nvim)
end

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldtext = "v:lua.FoldText()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local fold_augroup = vim.api.nvim_create_augroup("fold_method_selection", { clear = true })

local function set_fold_method()
    local filetype = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(filetype) or filetype
    local has_folds = lang and #vim.api.nvim_get_runtime_file("queries/" .. lang .. "/folds.scm", true) > 0
    local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
    local has_parser = ok and parser ~= nil

    if has_folds and has_parser then
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldexpr = "0"
    end
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = fold_augroup,
    callback = set_fold_method,
})

if vim.fn.has("termguicolors") then
    vim.opt.termguicolors = true
end

vim.cmd("set fillchars=fold:\\ ")
vim.cmd("let &t_SI = \"\\e[6 q\"")
vim.cmd("let &t_SR = \"\\e[4 q\"")
vim.cmd("let &t_EI = \"\\e[2 q\"")
