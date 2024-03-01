local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "autoflake",
    meta = {
        url = "https://github.com/PyCQA/autoflake",
        description = "Removes unused imports and unused variables as reported by pyflakes",
    },
    method = { FORMATTING },
    filetypes = { "python" },
    generator_opts = {
        command = "autoflake",
        args = {
            "--remove-all-unused-imports",
            "--ignore-init-module-imports",
            "--remove-unused-variables",
            "--expand-star-imports",
            "--stdin-display-name",
            "$FILENAME",
            "-" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
})
