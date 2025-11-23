return {
    -- "BartSte/nvim-bartste-prompts",
    dir = "~/code/personal/lua/nvim-bartste-prompts",
    --- Initialize and configure the prompts plugin
    -- @param plugin PluginSpec The plugin specification table
    -- @return nil
    cond = require("helpers.platform").is_linux(),
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("config.prompts")
    end
}
