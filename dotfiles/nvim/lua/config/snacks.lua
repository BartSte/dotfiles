local m = require("helpers.keymapper")
local snacks = require("snacks")


snacks.setup {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
}

m.nnoremap("<space>qq", Snacks.bufdelete.delete)
m.nnoremap("<space>qo", Snacks.bufdelete.other)
m.nnoremap("<space>qa", Snacks.bufdelete.all)

m.nnoremap("<space>go", Snacks.gitbrowse.open)
m.nnoremap("<space>gO", Snacks.gitbrowse.get_url)

m.nnoremap("<space>nh", Snacks.notifier.show_history)
