-- Checkout the README.md for information how the configuration is organized.

-- The rtp is reset by lazy for performance reasons. Therefore,
-- lua/before/plugin is loaded through a funtion. After, lazy is setup, the
-- lua/before directory is added to the rtp, such that the lua/before/ftplugin
-- directory works as expected.
require("before.plugin").load()
require("config.lazy").setup()
require("before").set_rtp()
