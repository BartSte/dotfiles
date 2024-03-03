local this_dir = vim.fn.stdpath('config') .. '/lua/after/plugin'
local files = require("helpers.path").glob(this_dir)
for _, file in ipairs(files) do
    require(file).setup()
end
