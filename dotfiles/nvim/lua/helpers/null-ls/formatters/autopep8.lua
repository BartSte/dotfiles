local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING
local RANGE_FORMATTING = methods.internal.RANGE_FORMATTING

return helpers.make_builtin({
    name = "autopep8",
    meta = {
        url = "https://github.com/hhatto/autopep8",
        description = "A tool that automatically formats Python code to conform to the PEP 8 style guide.",
    },
    method = { FORMATTING, RANGE_FORMATTING },
    filetypes = { "python" },
    generator_opts = {
        command = "autopep8",
        args = helpers.range_formatting_args_factory(
            { "-" },
            "--line-range",
            nil,
            { use_rows = true }
        ),
        to_stdin = true,
    },
    factory = helpers.formatter_factory
})
