local m = require("helpers.keymapper")
local snacks = require("snacks")

local bigfile = {
    notify = true,            -- show notification when big file detected
    size = 1.5 * 1024 * 1024, -- 1.5MB
    -- Enable or disable features when big file detected
    ---@param ctx {buf: number, ft:string}
    setup = function(ctx)
        vim.schedule(function()
            vim.bo[ctx.buf].syntax = ctx.ft
        end)
    end,
}

snacks.setup {
    bigfile = bigfile,
    quickfile = { exclude = { "latex" } }
}

m.nnoremap("<space>qq", Snacks.bufdelete.delete)
m.nnoremap("<space>qo", Snacks.bufdelete.other)
m.nnoremap("<space>qa", Snacks.bufdelete.all)

m.nnoremap("<space>gb", Snacks.git.blame_line)
m.nnoremap("<space>go", Snacks.gitbrowse.open)
m.nnoremap("<space>gO", Snacks.gitbrowse.get_url)
