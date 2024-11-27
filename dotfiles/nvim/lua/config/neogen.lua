local mappers = require('helpers.keymapper') 
require('neogen').setup {
    enabled = true,
    languages = {
        python = { template = { annotation_convention = "google_docstrings" } }
    }
}

mappers.silent_noremap('<leader>d', '<cmd>Neogen<CR>')
