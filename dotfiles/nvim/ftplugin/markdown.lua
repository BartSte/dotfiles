local cmp = require("cmp")

local sources = {
    { name = 'path', priority = 1, keyword_length = 1 },
    { name = 'buffer', priority = 1, keyword_length = 3 },
    { name = 'luasnip', priority = 3, keyword_length = 1 },
    { name = 'nvim_lsp', priority = 5, keyword_length = 1 },
    { name = 'dictionary', priority = 6, keyword_length = 3 }
}

cmp.setup.buffer({
    sources = sources
})

vim.opt_local.spell = true
