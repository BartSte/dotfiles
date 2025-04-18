return {
    -- "BartSte/nvim-bartste-prompts",
    dir = "~/code/nvim-bartste-prompts",
    --- Initialize and configure the prompts plugin
    -- @param plugin PluginSpec The plugin specification table
    -- @return nil
    config = function()
        require("config.prompts")
    end
}
