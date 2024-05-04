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

M.buffer_cmap = bind("c", { buffer = true })
M.buffer_imap = bind("i", { buffer = true })
M.buffer_nmap = bind("n", { buffer = true })
M.buffer_omap = bind("o", { buffer = true })
M.buffer_vmap = bind("v", { buffer = true })
M.buffer_xmap = bind("x", { buffer = true })

M.buffer_cnoremap = bind("c", { buffer = true })
M.buffer_inoremap = bind("i", { buffer = true })
M.buffer_nnoremap = bind("n", { buffer = true })
M.buffer_noremap = bind("", { buffer = true })
M.buffer_onoremap = bind("o", { buffer = true })
M.buffer_tnoremap = bind("t", { buffer = true })
M.buffer_vnoremap = bind("v", { buffer = true })
M.buffer_xnoremap = bind("x", { buffer = true })

M.silent_cmap = bind("c", { noremap = false, silent = true })
M.silent_imap = bind("i", { noremap = false, silent = true })
M.silent_nmap = bind("n", { noremap = false, silent = true })
M.silent_omap = bind("o", { noremap = false, silent = true })
M.silent_vmap = bind("v", { noremap = false, silent = true })
M.silent_xmap = bind("x", { noremap = false, silent = true })

M.silent_cnoremap = bind("c", { silent = true })
M.silent_inoremap = bind("i", { silent = true })
M.silent_nnoremap = bind("n", { silent = true })
M.silent_noremap = bind("", { silent = true })
M.silent_onoremap = bind("o", { silent = true })
M.silent_tnoremap = bind("t", { silent = true })
M.silent_vnoremap = bind("v", { silent = true })
M.silent_xnoremap = bind("x", { silent = true })

M.silent_buffer_cmap = bind("c", { buffer = true, silent = true })
M.silent_buffer_imap = bind("i", { buffer = true, silent = true })
M.silent_buffer_nmap = bind("n", { buffer = true, silent = true })
M.silent_buffer_omap = bind("o", { buffer = true, silent = true })
M.silent_buffer_vmap = bind("v", { buffer = true, silent = true })
M.silent_buffer_xmap = bind("x", { buffer = true, silent = true })

M.silent_buffer_cnoremap = bind("c", { buffer = true, silent = true })
M.silent_buffer_inoremap = bind("i", { buffer = true, silent = true })
M.silent_buffer_nnoremap = bind("n", { buffer = true, silent = true })
M.silent_buffer_noremap = bind("", { buffer = true, silent = true })
M.silent_buffer_onoremap = bind("o", { buffer = true, silent = true })
M.silent_buffer_tnoremap = bind("t", { buffer = true, silent = true })
M.silent_buffer_vnoremap = bind("v", { buffer = true, silent = true })
M.silent_buffer_xnoremap = bind("x", { buffer = true, silent = true })

return M
