-- Checkout the README.md for information how the configuration is organized.

-- The `lua/after` directory is appended to the rtp option in `config.lazy`. The
-- `lua/before` needs to be prepended to the rtp but this is not straight
-- forward, as the rtp is reset by lazy for performance reasons. Therefore, the
-- `lua/before` directory is required through a function.
msg_ids = {
    lsp_attached = {},
}

require("helpers.debug").setup()
require("before").require_all()
require("helpers.lazy").bootstrap()
require("config.lazy").setup()
