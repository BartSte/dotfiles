-- Checkout the README.md for information how the configuration is organized.

-- The rtp is reset by lazy for performance reasons. Therefore,
-- lua/before/plugin is loaded through a funtion. After lazy is setup, the
-- lua/before is prepended to the rtp.
-- On the other hand, the `lua/after` directory is added to the rtp option in
-- lazy, which does not work when you want to prepend path to the rtp.
require("before.plugin").load()
require("helpers.lazy").bootstrap()
require("config.lazy").setup()
require("before").prepend_rtp()
