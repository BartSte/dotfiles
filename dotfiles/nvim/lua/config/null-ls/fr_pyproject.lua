local formatters = require("helpers.null-ls.formatters")

return {
    formatters.autopep8,
    formatters.autoflake,
    formatters.isort,
}
