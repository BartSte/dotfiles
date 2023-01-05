local null = require("null-ls")

null.setup({
    sources = {
        null.builtins.diagnostics.ruff,
        null.builtins.formatting.autopep8,
        null.builtins.formatting.ruff,
    }
})

