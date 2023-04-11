local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true }

    local function keymap_set(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end

    return keymap_set
end

M.nmap = bind("n", { noremap = false })
M.noremap = bind("")
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.cnoremap = bind("c")
M.tnoremap = bind("t")
M.buffer_nmap = bind("n", { noremap = false, buffer = true })
M.buffer_noremap = bind("", { buffer = true})
M.buffer_nnoremap = bind("n", { buffer = true})
M.buffer_vnoremap = bind("v", { buffer = true})
M.buffer_xnoremap = bind("x", { buffer = true})
M.buffer_inoremap = bind("i", { buffer = true})
M.buffer_cnoremap = bind("c", { buffer = true})
M.buffer_tnoremap = bind("t", { buffer = true})

return M
