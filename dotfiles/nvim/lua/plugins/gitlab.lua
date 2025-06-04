return {
    -- "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim",
    -- "BartSte/gitlab.vim",
    dir = "~/code/gitlab.vim",
    cond = function()
        return require("helpers.rbw").set_env("gitlabtoken", "GITLAB_TOKEN")
    end,
    config = function()
        require("config.gitlab")
    end
}
