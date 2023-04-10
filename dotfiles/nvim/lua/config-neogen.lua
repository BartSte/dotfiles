local mappers = require('keymapper')
require('neogen').setup {
    enabled = true,
    languages = {
        python = { template = { annotation_convention = "google_docstrings" } }
    }
}

mappers.noremap('<leader>n', '<cmd>Neogen<CR>')
