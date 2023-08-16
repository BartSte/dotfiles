local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})
lspconfig.vimls.setup({})
lspconfig.bashls.setup({ filetypes = { "sh", "bash", "zsh" } })
lspconfig.jsonls.setup({})

lspconfig.clangd.setup {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--header-insertion=iwyu",
        "--background-index",
        "--clang-tidy",
        "--pch-storage=memory",
    },
}
lspconfig.cmake.setup {}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

if vim.fn.has('win32') == 1 then
    lspconfig.powershell_es.setup({})
    lspconfig.marksman.setup({
        cmd = {
            "$LOCALAPPDATA\\nvim-data\\mason\\packages\\marksman\\marksman.exe",
            "server"
        }
    })
else
    lspconfig.marksman.setup({})
end
