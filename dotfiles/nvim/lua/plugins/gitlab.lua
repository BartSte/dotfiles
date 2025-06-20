return {
    -- "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim",
    "BartSte/gitlab.vim",
    -- dir = "~/code/gitlab.vim",
    config = function()
        require("config.gitlab")
    end
}
