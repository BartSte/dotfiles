require("saturate").setup({
    saturation = 3,
    palette = require("kanagawa.colors").setup({ theme = "dragon" }).palette,
    after = function(palette)
        require("kanagawa").setup({ colors = { palette = palette } })
        require("kanagawa").load()
    end
})
