require("focus").setup({
    enable = true,   -- Enable module
    commands = false, -- Create Focus commands
    autoresize = { enable = false },
    ui = {
        number = true,         -- Display line numbers in the focussed window only
        relativenumber = true, -- Display relative line numbers in the focussed window only
        hybridnumber = true,   -- Display hybrid line numbers in the focussed window only
        cursorline = true,     -- Display a cursorline in the focussed window only
        cursorcolumn = false,  -- Display cursorcolumn in the focussed window only
        colorcolumn = {
            enable = true,     -- Display colorcolumn in the foccused window only
            list = '+1',       -- Set the comma-saperated list for the colorcolumn
        },
        signcolumn = false,    -- Display signcolumn in the focussed window only
        winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
    }
})
