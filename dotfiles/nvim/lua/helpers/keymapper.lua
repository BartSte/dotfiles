---@alias KeymapRhs string|function
---@alias KeymapBinder fun(lhs: string, rhs: KeymapRhs, opts?: vim.keymap.set.Opts): nil
---@class KeyMapper
---@field cmap KeymapBinder
---@field imap KeymapBinder
---@field nmap KeymapBinder
---@field omap KeymapBinder
---@field vmap KeymapBinder
---@field xmap KeymapBinder
---@field cnoremap KeymapBinder
---@field inoremap KeymapBinder
---@field nnoremap KeymapBinder
---@field noremap KeymapBinder
---@field onoremap KeymapBinder
---@field tnoremap KeymapBinder
---@field vnoremap KeymapBinder
---@field xnoremap KeymapBinder
---@field buffer_cmap KeymapBinder
---@field buffer_imap KeymapBinder
---@field buffer_nmap KeymapBinder
---@field buffer_omap KeymapBinder
---@field buffer_vmap KeymapBinder
---@field buffer_xmap KeymapBinder
---@field buffer_cnoremap KeymapBinder
---@field buffer_inoremap KeymapBinder
---@field buffer_nnoremap KeymapBinder
---@field buffer_noremap KeymapBinder
---@field buffer_onoremap KeymapBinder
---@field buffer_tnoremap KeymapBinder
---@field buffer_vnoremap KeymapBinder
---@field buffer_xnoremap KeymapBinder
---@field silent_cmap KeymapBinder
---@field silent_imap KeymapBinder
---@field silent_nmap KeymapBinder
---@field silent_omap KeymapBinder
---@field silent_vmap KeymapBinder
---@field silent_xmap KeymapBinder
---@field silent_cnoremap KeymapBinder
---@field silent_inoremap KeymapBinder
---@field silent_nnoremap KeymapBinder
---@field silent_noremap KeymapBinder
---@field silent_onoremap KeymapBinder
---@field silent_tnoremap KeymapBinder
---@field silent_vnoremap KeymapBinder
---@field silent_xnoremap KeymapBinder
---@field silent_buffer_cmap KeymapBinder
---@field silent_buffer_imap KeymapBinder
---@field silent_buffer_nmap KeymapBinder
---@field silent_buffer_omap KeymapBinder
---@field silent_buffer_vmap KeymapBinder
---@field silent_buffer_xmap KeymapBinder
---@field silent_buffer_cnoremap KeymapBinder
---@field silent_buffer_inoremap KeymapBinder
---@field silent_buffer_nnoremap KeymapBinder
---@field silent_buffer_noremap KeymapBinder
---@field silent_buffer_onoremap KeymapBinder
---@field silent_buffer_tnoremap KeymapBinder
---@field silent_buffer_vnoremap KeymapBinder
---@field silent_buffer_xnoremap KeymapBinder
---@field expr_inoremap KeymapBinder
---@field expr_nnoremap KeymapBinder
---@field expr_vnoremap KeymapBinder
---@field expr_xnoremap KeymapBinder
---@field expr_onoremap KeymapBinder
---@field expr_tnoremap KeymapBinder
---@field expr_cnoremap KeymapBinder
local M = {}

---@param op string|string[]
---@param outer_opts? vim.keymap.set.Opts
---@return KeymapBinder
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

local expr_opts = { expr = true, noremap = true, silent = true, replace_keycodes = false }
M.expr_inoremap = bind("i", expr_opts)
M.expr_nnoremap = bind("n", expr_opts)
M.expr_vnoremap = bind("v", expr_opts)
M.expr_xnoremap = bind("x", expr_opts)
M.expr_onoremap = bind("o", expr_opts)
M.expr_tnoremap = bind("t", expr_opts)
M.expr_cnoremap = bind("c", expr_opts)

return M
