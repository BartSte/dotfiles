local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true }

    local function keymap_set(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end

    return keymap_set
end

M.cmap = bind("c", { noremap = false })
M.imap = bind("i", { noremap = false })
M.nmap = bind("n", { noremap = false })
M.omap = bind("o", { noremap = false })
M.vmap = bind("v", { noremap = false })
M.xmap = bind("x", { noremap = false })

M.cnoremap = bind("c")
M.cnoremap = bind("c")
M.inoremap = bind("i")
M.nnoremap = bind("n")
M.noremap = bind("")
M.onoremap = bind("o")
M.tnoremap = bind("t")
M.vnoremap = bind("v")
M.xnoremap = bind("x")

M.buffer_cmap = bind("c", { buffer = true})
M.buffer_imap = bind("i", { buffer = true})
M.buffer_nmap = bind("n", { buffer = true})
M.buffer_omap = bind("o", { buffer = true})
M.buffer_vmap = bind("v", { buffer = true})
M.buffer_xmap = bind("x", { buffer = true})

M.buffer_cnoremap = bind("c", { buffer = true})
M.buffer_inoremap = bind("i", { buffer = true})
M.buffer_nnoremap = bind("n", { buffer = true})
M.buffer_noremap = bind("", { buffer = true})
M.buffer_onoremap = bind("o", { buffer = true})
M.buffer_tnoremap = bind("t", { buffer = true})
M.buffer_vnoremap = bind("v", { buffer = true})
M.buffer_xnoremap = bind("x", { buffer = true})

return M
