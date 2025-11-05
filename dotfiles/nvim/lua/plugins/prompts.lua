return {
    -- "BartSte/nvim-bartste-prompts",
    dir = "~/code/personal/nvim-bartste-prompts",
    --- Initialize and configure the prompts plugin
    -- @param plugin PluginSpec The plugin specification table
    -- @return nil
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("config.prompts")
    end
}
