local null_ls = require("null-ls")
local formatters = require("helpers.null-ls.formatters")

return {
    formatters.autoflake,
    formatters.autopep8,
    formatters.isort,
    null_ls.builtins.diagnostics.pylint,
}
