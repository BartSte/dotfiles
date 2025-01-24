---@class KeyMapper
---@field cmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field imap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field nmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field omap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field vmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field xmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field cnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field inoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field nnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field noremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field onoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field tnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field vnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field xnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_cmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_imap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_nmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_omap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_vmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_xmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_cnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_inoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_nnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_noremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_onoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_tnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_vnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field buffer_xnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_cmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_imap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_nmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_omap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_vmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_xmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_cnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_inoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_nnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_noremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_onoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_tnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_vnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_xnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_cmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_imap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_nmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_omap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_vmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_xmap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_cnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_inoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_nnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_noremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_onoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_tnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_vnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
---@field silent_buffer_xnoremap fun(lhs: string, rhs: string | function, opts: table?): nil
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

local expr_opts = { expr = true, noremap = true, silent = true, replace_keycodes = false }
M.expr_inoremap = bind("i", expr_opts)
M.expr_nnoremap = bind("n", expr_opts)
M.expr_vnoremap = bind("v", expr_opts)
M.expr_xnoremap = bind("x", expr_opts)
M.expr_onoremap = bind("o", expr_opts)
M.expr_tnoremap = bind("t", expr_opts)
M.expr_cnoremap = bind("c", expr_opts)

return M
