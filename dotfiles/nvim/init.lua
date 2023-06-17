-- Checkout the README.md for information how the configuration is organized.
require('helpers.lazy').bootstrap()
require('lazy').setup('plugins', { change_detection = { enabled = false } })
