local fn = require("helpers.fn")
local map = require("helpers.keymapper")
local helpers = require("helpers.mermaid")

-- Command
vim.api.nvim_buf_create_user_command(0, "MermaidRender", function(opts)
    helpers.render(opts.args)
end, {
    nargs = "?",
    complete = "file",
})

vim.api.nvim_buf_create_user_command(0, "MermaidRenderHere", function(opts)
    local ext = fn.is_empty(opts.args) and "svg" or opts.args
    local output_path = vim.fn.expand("%:p:r") .. "." .. ext
    helpers.render(output_path)
end, {
    nargs = "?",
    complete = function()
        return { "svg", "png", "pdf", "jpg" }
    end,
})

map.buffer_nnoremap("<leader>ms", ":MermaidRenderHere<CR>", {
    desc = "Render Mermaid diagram as svg and store it in the same directory as the source file",
})
map.buffer_nnoremap("<leader>mp", ":MermaidRenderHere png<CR>", {
    desc = "Render Mermaid diagram as png and store it in the same directory as the source file",
})
map.buffer_nnoremap("<leader>md", ":MermaidRenderHere pdf<CR>", {
    desc = "Render Mermaid diagram as pdf and store it in the same directory as the source file",
})
map.buffer_nnoremap("<leader>mj", ":MermaidRenderHere jpg<CR>", {
    desc = "Render Mermaid diagram as jpg and store it in the same directory as the source file",
})
