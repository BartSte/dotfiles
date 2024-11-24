local m = require("helpers.keymapper")
local snacks = require("snacks")

snacks.setup {
    bigfile = { enable = true },
    quickfile = { exclude = { "latex" } },
    notifier = {
        timeout = 3000,
        level = vim.log.levels.TRACE,
    },
}

m.nnoremap("<space>qq", Snacks.bufdelete.delete)
m.nnoremap("<space>qo", Snacks.bufdelete.other)
m.nnoremap("<space>qa", Snacks.bufdelete.all)

m.nnoremap("<space>gb", Snacks.git.blame_line)
m.nnoremap("<space>go", Snacks.gitbrowse.open)
m.nnoremap("<space>gO", Snacks.gitbrowse.get_url)

m.nnoremap("<space>nh", Snacks.notifier.show_history)
