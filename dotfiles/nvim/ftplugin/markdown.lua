local cmp = require("cmp")
local cmp_dictionary = require("cmp_dictionary")

local sources = {
    { name = 'path', priority = 1, keyword_length = 1 },
    { name = 'buffer', priority = 1, keyword_length = 3 },
    { name = 'luasnip', priority = 3, keyword_length = 1 },
    { name = 'nvim_lsp', priority = 5, keyword_length = 1 },
    { name = 'dictionary', priority = 6, keyword_length = 3 }
}

-- Loading all dicts is slow hence is is only done when a specific file type is
-- opened.
cmp_dictionary.setup({
    dic = {
        spelllang = {
            en = "~/.config/nvim/dict/en.dict",
            nl = "~/.config/nvim/dict/nl.dict",
        },
    },
})

cmp.setup.buffer({
    sources = sources
})

vim.opt_local.spell = true
