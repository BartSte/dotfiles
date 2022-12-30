local mapper = require("keymapper")

vim.g.scrollfix = 50;
vim.g.fixeof = 0;
vim.g.scrollinfo = 1;

mapper.nnoremap("<leader>m", "<cmd>lua vim.g.scrollfix=50<CR><cmd>echo 'enabled scrollfix'<CR>")
mapper.nnoremap("<leader><leader>m", "<cmd>lua vim.g.scrollfix=-1<CR><cmd>set scrolloff=999<CR><cmd>echo 'disable scrollfix'<CR>")
