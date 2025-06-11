require("saturate").setup({
    saturation = 2,
    light_delta = 0.06,
    palette = require("kanagawa.colors").setup({ theme = "dragon" }).palette,
    after = function(palette)
        require("kanagawa").setup({ colors = { palette = palette } })
        require("kanagawa").load()
        vim.cmd("colorscheme kanagawa")
    end
})
