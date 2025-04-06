--- Configure environment variables for aider based on hostname
--- Sets API keys and model selection depending on current system
---@side effect Modifies vim.env with API keys and model selection
local function setup_env()
    local rbw = require("helpers.rbw")
    local hostname = vim.fn.hostname()
    if hostname == "bart-asus" then
        rbw.set_env("DEEPSEEK_API_KEY")
        vim.env["AIDER_MODEL"] = "deepseek/deepseek-reasoner"
    elseif hostname == "zbook" then
        rbw.set_env("OPENAI_API_KEY")
        vim.env["AIDER_MODEL"] = "o3-mini"
    end
end

setup_env()
Snacks.notify(string.format("AIDER_MODEL: %s", vim.env["AIDER_MODEL"]))
require("prompts").setup()
