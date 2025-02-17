return {
    'https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git',
    cond = function()
        return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ''
    end,
    config = function()
        require("config.duo")
    end
}
